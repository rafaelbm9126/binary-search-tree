const std = @import("std");
const print = @import("std").debug.print;

const Allocator = std.mem.Allocator;

const MAX_LENGTH_ITEMS = 15;

const Node = struct {
    data: usize,
    left: ?*Node,
    right: ?*Node,
};

fn insertNode(allocator: Allocator, node: *?*Node, data: usize) !void {
    const tmp: *Node = try allocator.create(Node);
    var new = Node{
        .data = data,
        .left = null,
        .right = null,
    };
    tmp.* = new;

    if (node.* == null) {
        node.* = tmp;
    } else {
        if (data > node.*.?.data) {
            try insertNode(allocator, &node.*.?.right, data);
        } else if (data < node.*.?.data) {
            try insertNode(allocator, &node.*.?.left, data);
        }
    }
}

fn PrintPreOrder(node: ?*Node) void {
    if (node != null) {
        print("PrintPreOrder: {d} \n", .{node.?.data});
        PrintPreOrder(node.?.left);
        PrintPreOrder(node.?.right);
    }
}

fn PrintInOrder(node: ?*Node) void {
    if (node != null) {
        PrintInOrder(node.?.left);
        print("PrintInOrder: {d} \n", .{node.?.data});
        PrintInOrder(node.?.right);
    }
}

fn GetArrayInOrder(node: ?*Node, array: *[MAX_LENGTH_ITEMS]usize, index: *usize) void {
    if (node != null) {
        GetArrayInOrder(node.?.left, array, index);
        array.*[index.*] = node.?.data;
        index.* += 1;
        GetArrayInOrder(node.?.right, array, index);
    }
}

fn PrintPostOrder(node: ?*Node) void {
    if (node != null) {
        PrintPostOrder(node.?.left);
        PrintPostOrder(node.?.right);
        print("PrintPostOrder: {d} \n", .{node.?.data});
    }
}

fn maxDepth(node: ?*Node) u8 {
    if (node != null) {
        var left_depth = maxDepth(node.?.left);
        var rigth_depth = maxDepth(node.?.right);

        if (left_depth > rigth_depth) {
            return left_depth + 1;
        } else {
            return rigth_depth + 1;
        }
    }
    return 0;
}

fn isBalanced(node: ?*Node) i8 {
    if (node != null) {
        var left_height = isBalanced(node.?.left);
        if (left_height == -1)
            return -1;

        var right_height = isBalanced(node.?.right);
        if (right_height == -1)
            return -1;

        if (@abs(left_height - right_height) > 1) {
            return -1;
        } else {
            return if (left_height > right_height)
                left_height + 1
            else
                right_height + 1;
        }
    }

    return 0;
}

pub fn main() !void {
    // ******* //
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();
    // ******* //
    var node: ?*Node = null;
    // ******* //

    var vector = [_]usize{ 40, 20, 10, 30, 60, 50, 70, 5, 15, 25, 35, 45, 55, 65, 75 };

    for (0..MAX_LENGTH_ITEMS) |i| {
        try insertNode(allocator, &node, vector[i]);
    }

    PrintPreOrder(node);
    PrintInOrder(node);
    PrintPostOrder(node);
    print("maxDepth: {d} \n", .{maxDepth(node)});
    print("isBalanced: {?} \n", .{isBalanced(node) > -1});
}
