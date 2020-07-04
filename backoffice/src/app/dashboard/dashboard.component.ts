import { Component, OnInit } from '@angular/core';
import { ReportingService } from '../services/reporting.service';

@Component({
  selector: 'app-dashboard',
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.css']
})
export class DashboardComponent implements OnInit {

  constructor(private reportingService: ReportingService) { }

  ngOnInit(): void {
    this.reportingService.fetchTasklist(data => {
      console.log(data);
    });
  }

}
