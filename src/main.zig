const std = @import("std");

const c = @cImport({
    @cInclude("iconv.h");
});

pub const Context = extern struct {
    context: c.iconv_t,
};

export fn ziconv_open(src: [*c]const u8, dst: [*c]const u8) Context {
    return .{ .context = c.iconv_open(dst, src) orelse @panic("Unable to open iconv") };
}

export fn ziconv_close(context: Context) void {
    if (c.iconv_close(context.context) == -1) {
        @panic("Unable to close iconv");
    }
}

export fn ziconv_convert(context: Context, src: [*c][*c]u8, dst: [*c][*c]u8, src_len: *usize, dst_len: *usize) usize {
    return c.iconv(context.context, src, src_len, dst, dst_len);
}
