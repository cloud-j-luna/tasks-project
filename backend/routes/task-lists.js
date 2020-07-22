const TaskList = require('../models/task-list').TaskList;
const TaskListRepository = require('../repository/task-list');
var express = require('express');
const { Task } = require('../models/task');
const taskList = require('../models/task-list');
var router = express.Router();

router.get('/', function (req, res, next) {
    TaskListRepository.Read(data => {
        res.json(data);
    });
    
});

router.post('/', function (req, res, next) {
    TaskListRepository.Read(data => {
        let all = data;

        console.log(all);

        for(let tasklist of req.body) {
            if(!tasklist.id || taskList.id == "" ) {
                TaskListRepository.Create(new TaskList(
                    tasklist.uuid,
                    tasklist.name,
                    tasklist.tasks,
                    tasklist.isFavourite,
                    tasklist.settings
                ));
                continue;
            }
            
            for(let t of all) {
                if(t.id === tasklist.id) {
                    TaskListRepository.Update(tasklist, tasklist.id);
                    break;
                }
            }
        }

        for(let t of all) {
            let foundInBody = false;
            for(let tasklist of req.body) {
                if(t.id === tasklist.id) {
                    foundInBody = true;
                    break;
                }
            }
            if(!foundInBody) TaskListRepository.Delete(t.id);
        }
        
        res.statusCode = 204;
        res.json(req.body);
    });
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
