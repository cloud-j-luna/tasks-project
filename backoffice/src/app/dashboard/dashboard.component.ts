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

    this.counters.set("Total task lists", 0);
    this.counters.set("Tasks in last 7 days", 0);
    this.counters.set("Completed task lists", 0);
    this.counters.set("Empty task lists", 0);
    this.counters.set("Time spent last 7 days (sec)", 0);

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
    this.reportingService.loadTasklists(data => {
      this.counters.set("Total task lists", this.reportingService.getTotalTasklists());
      this.counters.set("Tasks in last 7 days", this.reportingService.getTasksFrom7Days().length);
      this.counters.set("Completed task lists", this.reportingService.getCompletedTasklists().length);
      this.counters.set("Empty task lists", this.reportingService.getEmptyTaskLists().length);
      this.counters.set("Time spent last 7 days (sec)", this.reportingService.getTimeSpentInLast7Days());

      let tasks = this.reportingService.getStructuredTasksFrom7Days();
      for(let day in tasks) {
        this.multi.push({
          name: day,
          series: [
            {
              name: "created",
              value: tasks[day].length
            },
            {
              name: "completed",
              value: tasks[day].filter(elem => elem['status'] === 'TaskStatus.done').length
            }
          ]
        });
      }

      this.multi = this.multi.slice();
    });
  }

}
