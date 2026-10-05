\# Student Enrollment System



A database-driven web application developed as a four-member academic group project for the Web Application Development course.



The system provides students with a centralized platform for course enrollment, academic enquiries, timetable management, teaching evaluation, payment management, and account management.



\## Technologies Used



\- C#

\- ASP.NET Web Forms

\- Microsoft SQL Server

\- HTML

\- CSS

\- JavaScript

\- Bootstrap

\- Visual Studio



\## Main Features



\### Enrollment

\- Online Course Enrollment

\- Course Add / Drop

\- Add / Drop History



\### Enquiry \& Academic

\- Timetable Matching

\- Contact Us / Support

\- Enquiry History

\- Student Evaluation of Teaching (SET)



\### Finance \& Payment

\- Payment

\- Payment History

\- Student Statement

\- Receipt Management



\### Account Management

\- Profile Management

\- Bank Details

\- Registration Summary / Timetable



\## My Contribution



This project was developed by a team of four members.



My main responsibility was the \*\*Enquiry \& Academic module\*\*, including:



\- Developed the student enquiry and support feature.

\- Developed enquiry status and history tracking.

\- Developed the Student Evaluation of Teaching (SET) feature.

\- Developed the timetable matching/display feature.

\- Integrated the module with Microsoft SQL Server using C# and ASP.NET.

\- Worked with database insertion, retrieval, and display operations.

\- Contributed to database testing and ERD design.

\- Assisted with debugging and system integration.



\## Database



The system uses Microsoft SQL Server and includes tables for users, courses, enrollments, timetables, enquiries, evaluations, invoices, payments, student profiles, and other system data.



The database setup script is provided in:



`enrollmentdb.sql`



\## Running the Project



1\. Open `Project.slnx` using Visual Studio.

2\. Restore the required NuGet packages.

3\. Run `enrollmentdb.sql` using Microsoft SQL Server Management Studio (SSMS).

4\. Confirm that the `EnrollmentDB` database has been created.

5\. Check the connection string in `Project/Web.config`.

6\. Change the SQL Server instance name if necessary.

7\. Build and run the project using IIS Express.



Example connection string:



`Data Source=.\\SQLEXPRESS01;Initial Catalog=EnrollmentDB;Integrated Security=True;TrustServerCertificate=True`



\## Project Type



Academic Group Project — Web Application Development



Team Size: 4

