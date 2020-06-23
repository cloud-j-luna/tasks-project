class TaskList {
    constructor(name, description, tasks, isFavourite, allowsSimultaneousTasks) {
        this._name = name;
        this._description = description;
        this._tasks = tasks;
        this._isFavourite = isFavourite;
        this._allowsSimultaneousTasks = allowsSimultaneousTasks;
    }

    get id() { return this._id }
    set id(val) { this._id = val }

    get name() { return this._name }
    set name(val) { this._name = val }

    get description() { return this._description }
    set description(val) { this._description = val }

    get tasks() { return this._tasks }
    set tasks(val) { this._tasks = val }

    get isFavourite() { return this._isFavourite }
    set isFavourite(val) { this._isFavourite = val }

    get allowsSimultaneousTasks() { return this._allowsSimultaneousTasks }
    set allowsSimultaneousTasks(val) { this._allowsSimultaneousTasks = val }
}

module.exports = {
    TaskList
}