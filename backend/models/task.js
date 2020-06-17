class Task {
    constructor(name, description, subTasks, status, sessions, creationDate) {
        this._name = name;
        this._description = description;
        this._subTasks = subTasks;
        this._status = status;
        this._sessions = sessions;
        this._creationDate = creationDate;
    }

    get id() { return this._id }

    get name() { return this._name }
    set name(val) { this._name = val }

    get description() { return this._description }
    set description(val) { this._description = val }

    get subTasks() { return this._subTasks }
    set subTasks(val) { this._subTasks = val }

    get status() { return this._status }
    set status(val) { this._status = val }

    get sessions() { return this._sessions }
    set sessions(val) { this._sessions = val }

    get creationDate() { return this._creationDate }
    set creationDate(val) { this._creationDate = val }
}

class SubTask {
    constructor(id, name, description) {
        this._id = id;
        this._name = name;
        this._description = description;
    }

    get id() { return this._id }

    get name() { return this._name }
    set name(val) { this._name = val }

    get description() { return this._description }
    set description(val) { this._description = val }
}

const Status = Object.freeze({
    New: Symbol("new"),
    InProgress: Symbol("in-progress"),
    Paused: Symbol("paused"),
    Finished: Symbol("finished"),
    Archived: Symbol('archived'),
    Canceled: Symbol('canceled'),
    Deleted: Symbol('deleted')
});

module.exports = {
    Task,
    SubTask,
    Status
}