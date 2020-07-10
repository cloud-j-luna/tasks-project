import { AngularFirestore } from '@angular/fire/firestore';
import { Injectable } from '@angular/core';

const DAYS_BEFORE = 7;
const PAST_OFFSET = DAYS_BEFORE * 24 * 60 * 60 * 1000

@Injectable({providedIn: 'root'})
export class ReportingService {
    tasklists: any[];

    constructor(private firestore: AngularFirestore) {}

    fetchTasklists(callback) {
        return this.firestore
            .collection("tasklist")
            .snapshotChanges()
            .subscribe(res => callback(res.map(a => a.payload.doc.data())));
    }

    loadTasklists(callback) {
        return this.firestore
            .collection("tasklist")
            .snapshotChanges()
            .subscribe(res => {
                this.tasklists = res.map(a => a.payload.doc.data());
                callback(this.tasklists.slice());
            });
    }

    getTotalTasklists() : number {
        return this.tasklists.length;
    }

    getCompletedTasklists() {
        const result = [];
        for(let tasklist of this.tasklists) {
            if(!tasklist['_tasks'] || tasklist['_tasks'].length === 0) continue;
            let allDone = true;

            for(let task of tasklist['_tasks']) {
                if(task['status'] !== 'TaskStatus.done') {
                    allDone = false;
                    break;
                }
            }

            if(allDone) result.push(tasklist);
        }

        return result;
    }

    getTasksFrom7Days() {
        const allTasks = [];
        for(let tasklist of this.tasklists) {
            if(!tasklist['_tasks'] || tasklist['_tasks'].length === 0) continue;

            for(let task of tasklist['_tasks']) {
                let datePlus7 = new Date();
                datePlus7.setTime((new Date(task['createdTimestamp'])).getTime() + PAST_OFFSET);
                if(datePlus7.getTime() > Date.now()) {
                    allTasks.push(task);
                }
            }
        }

        return allTasks;
    }

    getStructuredTasksFrom7Days() {
        const tasks = this.getTasksFrom7Days();
        const result = {};

        for(let task of tasks) {
            let key = new Date(task.createdTimestamp).toDateString();
            if(!result[key]) result[key] = [];

            result[key].push(task);
        }

        return result;
    }

    getEmptyTaskLists() {
        return this.tasklists.filter(tl => !tl.tasks || tl.tasks.length === 0).slice();
    }
}