---
layout: post
title: automation
date: 2015-11-22 21:40:51
categories:
---

This sunday's challenge was to maintain a service which provides the latest version info of an iOS application.

Previously, we used to update this info manually each time new version gets approved and released on appstore. But as one can easily guess, this leads to problems like delays, misses updating the same.

***"Mistakes tend to occur whenever work is manual"***

Here comes the savior...__Fastlane's Spaceship__. Using this one can fetch iOS app info from iTunes connect and developer portal.

Now lets automate:

* Create a cron job to run our script everyday.
* Script contains fetching app info from iTunes connect and update the same on our servers.



By the way, this led me to explore cron jobs more and think about solving my day to day problems with cron jobs.

* To start, I created a basic cron job which posts notification on mac osx every 20 minutes. Notification reminds user to take a break from work.

* Also, a created a cron job to remind me continuously about informing team about standup status. Till I act on the notification, notification is continuously posted every 15 minutes in the morning for few hours. Once action is taken, notification is posted next day. BTW this makes sure it only reminds on weekdays.


By the end of day, I again fell in love with cron jobs.