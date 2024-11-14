const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "zig_rust_ffi",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const tool_run = b.addSystemCommand(&.{"cargo"});
    tool_run.setCwd(b.path("src"));
    tool_run.addArgs(&.{
        "build"
    });
    var opt_path: []const u8 = undefined;
    switch (optimize) {
        .ReleaseSafe,
        .ReleaseFast,
        .ReleaseSmall,
        => {
            tool_run.addArg("--release");
            opt_path = "release";
        },
        .Debug => {
            opt_path = "debug";
        },
    }
    const generated = try b.allocator.create(std.Build.GeneratedFile);
    generated.* = .{
        .step = &tool_run.step,
        .path = try b.build_root.join(b.allocator, &.{ "./target", opt_path, "libzig_rust_ffi.a" }),
    };
    const libgui_path = .{ .generated = .{ .file = generated } };
    exe.addLibraryPath(libgui_path.dirname());
    exe.linkSystemLibrary(".");

    exe.addIncludePath(b.path("."));

    exe.linkLibC();
    exe.linkLibCpp();
    b.installArtifact(exe);
    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}