import { Component, OnInit } from '@angular/core';
import { ReportingService } from '../services/reporting.service';
import { AuthService } from '../auth/auth.service';

@Component({
  selector: 'dashboard',
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.css']
})
export class DashboardComponent implements OnInit {

  constructor(private reportingService: ReportingService, public authService: AuthService) {
    this.multi = [];

    this.counters.set("TOTAL 1", 20);
    this.counters.set("TOTAL 2", 20);
    this.counters.set("TOTAL 3", 20);
    this.counters.set("TOTAL 4", 20);
    this.counters.set("TOTAL 5", 20);
    this.counters.set("TOTAL 6", 20);

  }

  showXAxis: boolean = true;
  showYAxis: boolean = true;
  gradient: boolean = false;
  showXAxisLabel: boolean = true;
  showYAxisLabel: boolean = true;
  animations: boolean = true;
  colorScheme = {
    domain: ['#3088FD', '#5856FF']
  };
  multi: any[];


  counters: Map<string, number> = new Map<string, number>();

  ngOnInit(): void {
    this.reportingService.fetchTasklists(data => {
      //console.log(data);
    });

    this.reportingService.loadTasklists(data => {
      console.log(this.reportingService.getCompletedTasklists());
    });
  }

}
