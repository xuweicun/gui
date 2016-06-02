function User(id, uname, write) {
    // 用户ID
    this.id = id;
    // 用户名
    this.username = uname;
    // 写权限
    this.can_write = write;
}