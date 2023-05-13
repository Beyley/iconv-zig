const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});

    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "iconv-zig",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    lib.linkLibC();

    //On windows, lets use win-iconv, since windows does not provide an iconv implementation
    if (target.getOsTag() == .windows) {
        lib.addIncludePath(root_path ++ "win-iconv/");
        lib.addCSourceFiles(&.{root_path ++ "win-iconv/win_iconv.c"}, &.{});
    } else {
        lib.linkSystemLibrary("iconv");
    }

    b.installArtifact(lib);
}

fn root() []const u8 {
    return std.fs.path.dirname(@src().file) orelse ".";
}

const root_path = root() ++ "/";
