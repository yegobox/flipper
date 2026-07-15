use base64::{Engine, engine::general_purpose::STANDARD};
use serde_json::{Map, Value as JsonValue};
use std::ffi::{CStr, c_char};

use crate::{
    error::{Error, Result},
    params::Params,
    rows::Rows,
    value::Value,
};

pub unsafe fn c_char_to_str<'a>(ptr: *const c_char) -> Result<&'a str> {
    if ptr.is_null() {
        return Err(Error {
            message: "null pointer argument".into(),
        });
    }
    unsafe {
        CStr::from_ptr(ptr).to_str().map_err(|e| Error {
            message: e.to_string(),
        })
    }
}

fn value_to_json(value: Value) -> JsonValue {
    match value {
        Value::Integer(i) => JsonValue::Number(i.into()),
        Value::Real(f) => {
            // f64 can be NaN or Infinity which serde_json can't represent —
            // fall back to null to keep the output valid JSON
            serde_json::Number::from_f64(f)
                .map(JsonValue::Number)
                .unwrap_or(JsonValue::Null)
        }
        Value::Text(s) => JsonValue::String(s),
        Value::Blob(bytes) => JsonValue::String(STANDARD.encode(bytes)),
        Value::Null => JsonValue::Null,
    }
}

pub async fn convert_rows_to_json(rows: &mut Rows) -> Result<String> {
    let column_names = rows.column_names();
    let column_count = rows.column_count();
    let mut rows_json: Vec<JsonValue> = Vec::new();

    while let Some(row) = rows.next().await? {
        let mut obj = Map::with_capacity(column_count);

        for idx in 0..column_count {
            let name = column_names[idx].clone();
            let value = row.get_value(idx)?;
            obj.insert(name, value_to_json(value));
        }

        rows_json.push(JsonValue::Object(obj));
    }

    serde_json::to_string(&rows_json).map_err(|e| Error::new(&e.to_string()))
}

pub fn json_to_params(params_json: *const c_char) -> Result<Params> {
    if params_json.is_null() {
        Ok(Params::None)
    } else {
        match unsafe { c_char_to_str(params_json) }.and_then(|s| Params::from_json(s)) {
            Ok(p) => return Ok(p),
            Err(e) => return Err(e),
        }
    }
}
