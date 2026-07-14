pub struct Error {
    pub message: String,
}

impl Error {
    pub fn new(message: &str) -> Self {
        Self {
            message: message.to_string(),
        }
    }
}

impl From<turso_sdk_kit::rsapi::TursoError> for Error {
    fn from(value: turso_sdk_kit::rsapi::TursoError) -> Self {
        Self {
            message: format!("{:?}", value),
        }
    }
}

impl From<serde_json::Error> for Error {
    fn from(value: serde_json::Error) -> Self {
        Self {
            message: format!("{:?}", value),
        }
    }
}

pub type Result<T> = std::result::Result<T, Error>;
