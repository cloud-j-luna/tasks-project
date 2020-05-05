const TaskList = require('../models/task-list').TaskList;
var express = require('express');
var router = express.Router();

mockLists = [
    new TaskList(
        "id-01",
        "Frontend UI/UX",
        "Frontend tasks for UI/UX",
        ["task1", "task2", "task3"],
        true
    ),
    new TaskList(
        "id-02",
        "Backend Refactor",
        "Backend refactoring effort task list",
        ["task1", "task2"],
        true
    ),
    new TaskList(
        "id-03",
        "Bugs Release 1",
        "Bug list for Release 1",
        ["task1", "task2", "task3", "task4", "task5"],
        false
    ),
];

router.get('/', function (req, res, next) {
    taskLists = mockLists;
    res.json(taskLists);
});

router.post('/', function (req, res, next) {
    mockLists.append(req.body.taskList);
    res.sendStatus(201);
});

module.exports = router;
