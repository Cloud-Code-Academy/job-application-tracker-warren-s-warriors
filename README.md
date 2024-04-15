# Job Application Tracker on Salesforce 🚀

Dive into the Salesforce platform and channel its capabilities to redefine your job application tracking experience. This capstone project, a part of Cloud Code Academy's curriculum, aims to cultivate a proficient Salesforce developer out of you.

## About This Project 📖

Job searching can often become chaotic. With this project, we bring structure and efficiency into the process. Using Salesforce's versatile capabilities, you'll be building features that keep track of applications and add layers of automation, integration, and validation.

Key Features:
- Reminders: Set automated reminders for upcoming interviews, follow-ups, or essential dates.
- Validations: Assure the integrity of data with programmatic validations.
- Salary Calculations: Implement dynamic functionalities for salary calculations based on set parameters.
- Integration with Job Boards: Sync your application seamlessly with top job boards for updated tracking.

Navigating the Project 🧭

- Team or Solo: Opt to face this challenge solo or form a powerhouse team of up to three.
- Organizational Setup: Work within individual Salesforce orgs and religiously update the designated GitHub repository.
- Collaborate, But Stand Alone: While collaboration is the essence, ensure your team understands every project aspect.
- Reach Out: The ambiguous nature of requirements simulates the real world. Always clarify doubts with your instructor.

Key Recommendations 📝

- Embrace Ambiguity: Not all requirements might see completion - and that's okay!
- Management Tools: Organize and prioritize using tools like Trello or Jira.
- Code Over Click: Although tempting, emphasize coded solutions over Salesforce's declarative features.
- Fresh Start: Start with a fresh Trailhead Playground or Developer org to avoid existing automation or configuration.

## Installing the app using a Scratch Org

1. Set up your environment

    - Enable Dev Hub in your org
    - Install Salesforce CLI
    - Install Visual Studio Code
    - Install the Visual Studio Code Salesforce extensions

1. If you haven't already done so, authorize your hub org and provide it with an alias (**myhuborg** in the command below):

    ```
    sf org login web -a myhuborg -d
    ```

1. Clone the Job Application Tracker repository:

    ```
    git clone https://github.com/Cloud-Code-Academy/job-application-tracker-warren-s-warriors
    cd job-application-tracker-warren-s-warriors
    ```

1. Create a scratch org and provide it with an alias (**jat** in the command below):

    ```
    sf org create scratch -f config/project-scratch-def.json -a jat -y 30 -d
    ```

1. Push the app to your scratch org:

    ```
    sf project deploy start
    ```

1. Assign the **Job_Application_Tracker_User** permission set group to the default user:

    ```
    sf org assign permset -n Job_Application_Tracker_User
    ```

1. Open the scratch org:

    ```
    sf org open
    ```

1. In App Launcher, click **View All** then select the **Job Application Tracker** app

## Helpful Resources 🛠️

- [Apex Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_dev_guide.htm)
- [Salesforce Stack Exchange](https://salesforce.stackexchange.com/)
- [Visual Studio Code Documentation](https://code.visualstudio.com/docs)
- [Salesforce Extensions for Visual Studio Code](https://developer.salesforce.com/tools/vscode/)

Remember, the coding journey is filled with exploration, mistakes, learning, and growth. Enjoy this process, and here's wishing you success in your Salesforce journey with Cloud Code Academy! 🌟