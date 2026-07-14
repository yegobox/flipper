use base64::Engine;
use serde_json::Value as JsonValue;

use crate::error::Error;

pub enum Params {
    Positional(Vec<turso_sdk_kit::rsapi::Value>),
    Named(Vec<(String, turso_sdk_kit::rsapi::Value)>),
    None,
}

impl Params {
    pub fn from_json(json: &str) -> Result<Self, Error> {
        let v: JsonValue = serde_json::from_str(json).map_err(|e| Error::new(&e.to_string()))?;

        match v {
            JsonValue::Null => Ok(Self::None),
            JsonValue::Array(arr) => {
                let values = arr
                    .iter()
                    .map(json_to_value)
                    .collect::<Result<Vec<_>, _>>()?;
                Ok(Self::Positional(values))
            }
            JsonValue::Object(obj) => {
                let pairs = obj
                    .iter()
                    .map(|(k, v)| json_to_value(v).map(|pv| (k.clone(), pv)))
                    .collect::<Result<Vec<_>, _>>()?;
                Ok(Self::Named(pairs))
            }
            _ => Err(Error::new("params must be null, array, or object")),
        }
    }
}

fn json_to_value(v: &JsonValue) -> Result<turso_sdk_kit::rsapi::Value, Error> {
    match v {
        JsonValue::Null => Ok(turso_sdk_kit::rsapi::Value::Null),
        JsonValue::Bool(b) => Ok(turso_sdk_kit::rsapi::Value::from_i64(*b as i64)),
        JsonValue::Number(n) => {
            // prefer integer if it fits, fall back to float
            if let Some(i) = n.as_i64() {
                Ok(turso_sdk_kit::rsapi::Value::from_i64(i))
            } else if let Some(f) = n.as_f64() {
                Ok(turso_sdk_kit::rsapi::Value::from_f64(f))
            } else {
                Err(Error::new(&format!("number out of range: {n}")))
            }
        }
        JsonValue::String(s) => Ok(turso_sdk_kit::rsapi::Value::from_text(s.clone())),
        JsonValue::Object(obj) => {
            // blob convention: {"$blob": "<base64>"}
            if let Some(JsonValue::String(encoded)) = obj.get("$blob") {
                let bytes = base64::engine::general_purpose::STANDARD
                    .decode(encoded)
                    .map_err(|e| Error::new(&e.to_string()))?;
                Ok(turso_sdk_kit::rsapi::Value::from_blob(bytes))
            } else {
                Err(Error::new(
                    "unexpected object in params — did you mean {\"$blob\": \"...\"} ?",
                ))
            }
        }
        JsonValue::Array(_) => Err(Error::new("nested arrays are not supported in params")),
    }
}
