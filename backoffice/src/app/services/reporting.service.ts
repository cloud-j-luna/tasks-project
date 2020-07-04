import { AngularFirestore } from '@angular/fire/firestore';
import { Injectable } from '@angular/core';

@Injectable({providedIn: 'root'})
export class ReportingService {
    constructor(private firestore: AngularFirestore) {}

    fetchTasklist(callback) {
        return this.firestore
            .collection("tasklist")
            .snapshotChanges()
            .subscribe(res => callback(res.map(a => a.payload.doc.data())));
    }
}