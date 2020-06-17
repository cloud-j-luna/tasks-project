class TaskList {
    constructor(name, description, tasks, isFavourite) {
        this._name = name;
        this._description = description;
        this._tasks = tasks;
        this._isFavourite = isFavourite;
    }

    get id() { return this._id }

    get name() { return this._name }
    set name(val) { this._name = val }

    get description() { return this._description }
    set description(val) { this._description = val }

    get tasks() { return this._tasks }
    set tasks(val) { this._tasks = val }

    get isFavourite() { return this._isFavourite }
    set isFavourite(val) { this._isFavourite = val }
}

module.exports = {
    TaskList
}