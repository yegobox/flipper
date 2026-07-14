use std::ffi::{CString, c_char, c_void};

use crate::error::Error;

#[repr(C)]
pub struct FFIResponse {
    pub ptr: *mut c_void,
    pub error_message: *mut c_char,
}

impl FFIResponse {
    pub fn ok(ptr: *mut c_void) -> FFIResponse {
        FFIResponse {
            ptr,
            error_message: std::ptr::null_mut(),
        }
    }

    pub fn err(e: Error) -> FFIResponse {
        FFIResponse {
            ptr: std::ptr::null_mut(),
            error_message: CString::new(e.message).unwrap().into_raw(),
        }
    }
}

#[repr(C)]
pub struct FFIBoolResponse {
    pub value: bool,
    pub error_message: *mut c_char,
}

impl FFIBoolResponse {
    pub fn ok(value: bool) -> FFIBoolResponse {
        FFIBoolResponse {
            value,
            error_message: std::ptr::null_mut(),
        }
    }

    pub fn err(e: Error) -> FFIBoolResponse {
        FFIBoolResponse {
            value: false,
            error_message: CString::new(e.message).unwrap().into_raw(),
        }
    }
}

#[repr(C)]
pub struct FFIStringResponse {
    pub value: *mut c_char,
    pub error_message: *mut c_char,
}

impl FFIStringResponse {
    pub fn ok(value: String) -> FFIStringResponse {
        FFIStringResponse {
            value: CString::new(value).unwrap().into_raw(),
            error_message: std::ptr::null_mut(),
        }
    }

    pub fn err(e: Error) -> FFIStringResponse {
        FFIStringResponse {
            value: std::ptr::null_mut(),
            error_message: CString::new(e.message).unwrap().into_raw(),
        }
    }
}
