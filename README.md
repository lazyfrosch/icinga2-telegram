Icinga 2 Notifications to Telegram
==================================

The repository shows how to configure Icinga 2 to send notifications via
[Telegram](https://www.telegram.org).

These can be send either to:
* Group Chats
* Personal User Chat

Please note that **only** the transport is encrypted, but not the actual
messages. (They can be seen be Telegram employees).

Start by [creating a new bot](https://core.telegram.org/bots#create-a-new-bot).

When you first message the bot with `/start` or add it to a group, you can get
updates via the Telegram API, to get the Chat ID you want to sent messages to.

    curl --silent "https://api.telegram.org/bot${TOKEN}/getUpdates"

Use this chat ID to add it to a user.

Checkout the example files to configure Icinga 2:

* [telegram-host-notification.sh](telegram-host-notification.sh)
* [telegram-service-notification.sh](telegram-service-notification.sh)
* [icinga2-example.conf](icinga2-example.conf)

## Screenshot

![Screenshot](screenshot.png)

## Attribution

These scripts and examples are based on a blog post:
http://metz.gehn.net/2016/01/monitoring-notifications-via-telegram/

Please check out his post too, I just refitted it to fit my needs.

## License

Since the original Author didn't pick a license; but put it public, I will choose CC-BY

    Copyright (c) 2016 Stefan Gehn <metz@gehn.net>

    Creative Commons Attribution 2.0 Generic (CC BY 2.0)
    https://creativecommons.org/licenses/by/2.0/

    You are free to:

    * Share — copy and redistribute the material in any medium or format
    * Adapt — remix, transform, and build upon the material
      for any purpose, even commercially.

    The licensor cannot revoke these freedoms as long as you follow the license terms.

    Under the following terms:

    * Attribution — You must give appropriate credit, provide a link to the license,
      and indicate if changes were made. You may do so in any reasonable manner,
      but not in any way that suggests the licensor endorses you or your use.

    No additional restrictions — You may not apply legal terms or technological measures
    that legally restrict others from doing anything the license permits.
