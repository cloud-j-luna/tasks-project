const TaskList = require('../models/task-list').TaskList;
const TaskListRepository = require('../repository/task-list');
var express = require('express');
const { Task } = require('../models/task');
var router = express.Router();

router.get('/', function (req, res, next) {
    TaskListRepository.Read(data => {
        res.json(data);
    });
    
});

router.post('/', function (req, res, next) {
    console.log(req.body);
    TaskListRepository.Create(new TaskList(
        req.body.name,
        req.body.description,
        [],
        false
    ));
    res.statusCode = 201;
    res.json(req.body);
});

router.get('/:id', function (req, res, next) {

    res.json(mockLists[req.params.id]);
});

router.put('/:id', function (req, res, next) {

    // mockLists.push(req.body.taskList);
    // TaskListRepository.CreateTaskList(mockLists[0]);
    // res.statusCode = 200;
    // res.json(mockLists[0]);
});

router.delete('/:id', function (req, res, next) {
    // mockLists.push(req.body.taskList);
    // TaskListRepository.CreateTaskList(mockLists[0]);
    // res.statusCode = 200;
    // res.json(mockLists[0]);
});

module.exports = router;
