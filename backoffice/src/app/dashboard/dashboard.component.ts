import { Component, OnInit } from '@angular/core';
import { ReportingService } from '../services/reporting.service';
import { AuthService } from '../auth/auth.service';

@Component({
  selector: 'dashboard',
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.css']
})
export class DashboardComponent implements OnInit {

  constructor(private reportingService: ReportingService, public authService: AuthService) { }

  ngOnInit(): void {
    this.reportingService.fetchTasklists(data => {
      //console.log(data);
    });

    this.reportingService.loadTasklists(data => {
      console.log(this.reportingService.getCompletedTasklists());
    });
  }

}
