class User {
    constructor(name, email) {
        this.name = name;
        this.email = email;
    }

    get name() { return this.name }

    get name(val) { this.name = val }

    get email() { return this.email }

    get email(val) { this.email = val }
}

module.exports = {
    User
}