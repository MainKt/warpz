const std = @import("std");
const warpz = @import("warpz");
const clap = @import("clap");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const instructions =
        \\-h, --help                  Print this help message.
        \\-v, --version               Print the version and exit.
        \\-f, --foreground            Run warpz in the foreground (useful for debugging).
        \\-c, --config <str>          Use the supplied config file.
        \\-l, --list-keys             Print all valid keys.
        \\-q, --query                 Consumes a list of hints from stdin and presents a one off hint selection.
        \\--list-options              Print all available config options.
        \\--hint                      Start warpz in hint mode and exit after the end of the session.
        \\--hint2                     Start warpz in two pass hint mode and exit after the end of the session.
        \\--normal                    Start warpz in normal mode and exit after the end of the session.
        \\--grid                      Start warpz in hint grid and exit after the end of the session.
        \\--screen                    Start warpz in screen selection mode and exit after the end of the session.
        \\--oneshot                   When paired with one of the mode flags, exit warpz as soon as the mode is complete (i.e don't drop into normal mode). Principally useful for scripting.
        \\--move <usize> <usize>      Move the pointer to the specified coordinates.
        \\--click <usize>             Send a mouse click corresponding to the supplied button and exit. May be paired with --move.
        \\--record                    When used with --click, records the event in warpz's hint history.
        \\
    ;

    const params = comptime clap.parseParamsComptime(instructions);

    var diag = clap.Diagnostic{};
    var res = clap.parse(clap.Help, &params, clap.parsers.default, .{
        .diagnostic = &diag,
        .allocator = gpa.allocator(),
    }) catch |err| {
        diag.report(std.io.getStdErr().writer(), err) catch {};
        return err;
    };
    defer res.deinit();

    if (res.args.help != 0) {
        std.debug.print("{s}", .{instructions});
    }
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
