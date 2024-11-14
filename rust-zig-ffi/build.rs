use std::{env, fs, path::Path};

const LIB_NAME: &str = "rust_zig_ffi";
const ZIG_OUT_DIR: &str = "./zig-out/lib";

fn main() {
    // Define the shared library name for Linux
    let lib_extension = "so"; // Change from "dll" to "so"
    let rust_root = env::var("CARGO_MANIFEST_DIR").unwrap();
    let profile = env::var("PROFILE").unwrap();
    let lib_name = format!("lib{}.{}", LIB_NAME, lib_extension); // Prefix with "lib" for .so files
    let out_dir = Path::new(&rust_root).join("target").join(&profile);

    let src_path = Path::new(ZIG_OUT_DIR).join(&lib_name);
    let dst_path = Path::new(&out_dir).join(&lib_name);

    if !src_path.exists() {
        panic!(
            "{} not found. Run `zig build` first.",
            src_path.display()
        );
    }

    fs::copy(&src_path, &dst_path).unwrap();
}