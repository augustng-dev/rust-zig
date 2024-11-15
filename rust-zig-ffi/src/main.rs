fn add(a: i32, b: i32) -> Result<i32, Box<dyn std::error::Error>> {
    unsafe {
        let lib = libloading::Library::new("librust_zig_ffi.so")?;
        let add: libloading::Symbol<unsafe extern "C" fn(i32, i32) -> i32> = lib.get(b"add")?;
        Ok(add(a, b))
    }
}

fn main() {
    let a = 1;
    let b = 2;
    let c = add(a, b).unwrap();
    println!("librust_zig_ffi.so: add({}, {}) = {}", a, b, c);
}