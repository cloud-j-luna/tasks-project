class User {
    constructor(name, email) {
        this.name = name;
        this.email = email;
    }

    get name() { return this.name }

    set name(val) { this.name = val }

    get email() { return this.email }

    set email(val) { this.email = val }
}

module.exports = {
    User
}