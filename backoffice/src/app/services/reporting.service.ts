import { AngularFirestore } from '@angular/fire/firestore';
import { Injectable } from '@angular/core';

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
                datePlus7.setDate((task['createdTimestamp']).getDate() + 7)
                if(datePlus7 > new Date(Date.now())) {
                    allTasks.push(task);
                }
            }
        }

        return allTasks;
    }
}