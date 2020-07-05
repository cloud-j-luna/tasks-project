import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { AngularFireModule } from "@angular/fire";
import { AngularFirestoreModule } from "@angular/fire/firestore";

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { DashboardComponent } from './dashboard/dashboard.component';
import { LoginComponent } from './login/login.component';
import { AuthService } from './auth/auth.service';
import { SingUpComponent } from './sing-up/sing-up.component';
import { ForgotPasswordComponent } from './forgot-password/forgot-password.component';

const environment = {
  production: false,
  firebaseConfig: {
    type: "service_account",
    projectId: "tasks-project-ca5f2",
    private_key_id: "d896033ec664cfbc481d190487c97a71b0267eb6",
    private_key: "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDKUImTBWPM4VX/\nRlS2M1wqjoGORG+/YpLV6+3HHYdQNxG3iG9PZTOLjhVtWp/YpD9gmo/+35tyWgHw\nn8AShy254ksbiF5R5rlyXrk1k3JfxYMFvgOlyQGj7Sh4sFEzc4oYkFpt30SNPl60\nkkNq17lZrw12yC5HyGPHQUa49g8HmaZAOJjXjj/5XYkiIOH5jgA17Q8MooVdVoec\n7dMdF6XrApsAp0kp5EKZ4XqXR2Y+2J2yB1hBmdeF5xpMs5c6qWTS56JzBNt8lG7x\n4WuBhTAikokL+MMz2xAqe/Y0xzErzSv5007rSlOmfnC2JNGs3z0uG9JtSc/8izV1\nB1rwvbUnAgMBAAECggEAE8PDdPABXHolHx+9VeF1nxi18nKgIifcpXZ7j8jEN+Nx\nYSc8jJqb6wXR9RF17UG6iVMAP0uUEZtWdi39IzI+ltrTMJjlcgXi1xgG6wOBGHcg\nwjZaf98/wEaCfivneunOM3EizHoT5eKSePyTBoSVsHvICnMrBks+6C/p21b6h+jf\nwxD9CZXk4hjv39SOH9Nx5jNJbq8EIfou6W6xLCzbhH5IYazj0sa0z//EwASCmeie\n6UupX4ESdv26zqSxPQkS71UCIRV3Vuv5ez40OHBisW6RYeXnoRPmPS069dJIs894\nasNekcOVMfXUqbhB7MAveqyi567X2JXF7tQJroUdfQKBgQDzLZBpb9rRjS8oYdpj\nCyG/mf4nPv/1q4bDnlihUZFqdDqd+4c1GWP8pyuYF8tEagq3Lq60bbf371PtArxL\nulPgoRkzdEbNRNQTqogcJl9XK6YagsVFpjErIeNml7UqIlgbcK6fTGubyth83xdh\nXYNFnRqY8eeCpq/iGiuKGWa/zQKBgQDU+2VjGhgNpAbLZhLMPvLZza+0ccr+K/OE\nHWL4TYMqb8WdQlSeLxFkm58LMM4ip3ke6hVMrNHcYwwZBZza4E3XL5bqs/zfwqoh\nDYEJMp6TOBZxWzAH3Cv9vaqbxEkLiAp6JSahx9kP4cPLwPG+Zi+YXoUXAK6XVFAE\n8QVrTGwMwwKBgFYAxVQk1RTLg+QaR2xD4Zmr0rD6nPe7xBunAt16xZ0KojiBXp4u\n7qfKT6aos6DsiAGlJvB05V1wbRQjpYh6y3NkRk9mTiwGraKO6zhZcdqYe1Rg73fk\ngPsqLwx3lwDhyJtbzMZV9rDQmqP/Gnu64NRb7a4tz5zrasTiUIe02Bv5AoGBAKaU\n1pDzqNqKb5IJDSzZE2MNgJ723dl9EONFhNJG9g9sCrlcVwi+MbFqErRTAPeT26U1\nW2F0TlQ82Ap+HFgJVni3TSfXjTKKdDyT7lf+Uo89MDiLJP8Q0wuMnHNmy+cMCX3N\nrvCcegb1AwpLqAjOre1UCG6cZvIPzOKAjUeGJ4C3AoGAOTljTkaJf+vSUjAWVeoN\nXXS1INOJMLwOkmbe644JNwLU7NsQ+QNuacRJ3skhZrSmAKoW04yGVsLt/eN+9lX2\nFs5UAUGMIEx7oUnSdIeVSQI7bkq7bh1oDUlmY7bRlL9j5PdyScAnuH9RMHcrVKNk\nzSmPFG+Vmp+SPfy1I+ut08Y=\n-----END PRIVATE KEY-----\n",
    client_email: "firebase-adminsdk-qtzrt@tasks-project-ca5f2.iam.gserviceaccount.com",
    client_id: "108934530511457545494",
    auth_uri: "https://accounts.google.com/o/oauth2/auth",
    token_uri: "https://oauth2.googleapis.com/token",
    auth_provider_x509_cert_url: "https://www.googleapis.com/oauth2/v1/certs",
    client_x509_cert_url: "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-qtzrt%40tasks-project-ca5f2.iam.gserviceaccount.com",
    apiKey: "AIzaSyBxBao-pUt9Yc3SeXwG_ycCn6xmNEnMkyE",
    authDomain: "tasks-project-ca5f2.firebaseapp.com",
    databaseURL: "https://tasks-project-ca5f2.firebaseio.com",
    storageBucket: "tasks-project-ca5f2.appspot.com",
    messagingSenderId: "969210256952",
    appId: "1:969210256952:web:d5e7bdeefee881ba6b50cd",
    measurementId: "G-QR580XDRT7"
  }  
};

@NgModule({
  declarations: [
    AppComponent,
    DashboardComponent,
    LoginComponent,
    SingUpComponent,
    ForgotPasswordComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    AngularFireModule.initializeApp(environment.firebaseConfig),
    AngularFirestoreModule
  ],
  providers: [AuthService],
  bootstrap: [AppComponent]
})
export class AppModule { }
