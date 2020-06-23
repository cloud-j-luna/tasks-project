class TaskList {
    constructor(uuid, name, tasks, isFavourite, settings) {
        this._uuid = uuid;
        this._name = name;
        this._tasks = tasks;
        this._isFavourite = isFavourite;
        this._settings = settings;
    }

    get id() { return this._id }
    set id(val) { this._id = val }

    get uuid() { return this._uuid }
    set uuid(val) { this._uuid = val }

    get name() { return this._name }
    set name(val) { this._name = val }

    get tasks() { return this._tasks }
    set tasks(val) { this._tasks = val }

    get isFavourite() { return this._isFavourite }
    set isFavourite(val) { this._isFavourite = val }

    get settings() { return this._settings }
    set settings(val) { this._settings = val }
}

module.exports = {
    TaskList
}