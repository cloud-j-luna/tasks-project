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
    for(let tasklist of req.body) {
        TaskListRepository.Create(new TaskList(
            tasklist.uuid,
            tasklist.name,
            tasklist.tasks,
            tasklist.isFavourite,
            tasklist.settings
        ));
    }
    
    res.statusCode = 201;
    res.json(req.body);
});

router.get('/:id', function (req, res, next) {
    console.log(req.params.id);
    TaskListRepository.Read(data => {
        res.json(data);
    }, req.params.id);
});

router.put('/:id', function (req, res, next) {
    TaskListRepository.Update(req.body, req.params.id);
    res.end();
});

router.delete('/:id', function (req, res, next) {
    TaskListRepository.Delete(req.params.id);
    res.end();
});

module.exports = router;
