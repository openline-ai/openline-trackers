<div align="center">
  <a href="https://openline.ai">
    <img
      src="https://www.openline.ai/TeamHero.svg"
      alt="Openline Logo"
      height="64"
    />
  </a>
  <br />
  <p>
    <h3>
      <b>
        Tracked data models
      </b>
    </h3>
  </p>
  <p>

[![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen?logo=github)][repo] 
[![license](https://img.shields.io/badge/license-Apache%202-blue)][apache2] 
[![stars](https://img.shields.io/github/stars/openline-ai/openline-trackers?style=social)][repo] 
[![twitter](https://img.shields.io/twitter/follow/openlineAI?style=social)][twitter] 
[![slack](https://img.shields.io/badge/slack-community-blueviolet.svg?logo=slack)][slack]

  </p>
  <p>
    <sub>
      Built with ❤︎ by the
      <a href="https://openline.ai">
        Openline
      </a>
      community!
    </sub>
  </p>
</div>

## 👋 Overview

These models are written in a format that is runnable via [SQL-runner][sql-runner]

## 🤝 Prerequisites

Following environment variables are required to be provided for postgres DB connection:
* `DB_USER`
* `DB_PWD`
* `DB_HOST`
* `DB_PORT`

## 🚀 Running models

### Local
For local run, use `run.sh` script for single execution.

### Production
Use latest [docker image][docker].
For continuous data modeling set-up a cron job that will trigger app in docker container.

## 🤝 Resources

- For help, feature requests, or chat with fellow Openline enthusiasts, check out our [slack community][slack]!
- Our [docs site][docs] has references for developer functionality, including the Graph API

## 💪 Contributions

- We love contributions big or small!  Please check out our [guide on how to get started][contributions].
- Not sure where to start?  [Book a free, no-pressure, no-commitment call][call] with the team to discuss the best way to get involved.


[apache2]: https://www.apache.org/licenses/LICENSE-2.0
[call]: https://meetings-eu1.hubspot.com/matt2/customer-demos
[contributions]: https://github.com/openline-ai/community/blob/main/README.md
[docs]: https://openline.ai
[docker]: https://github.com/openline-ai/openline-trackers/pkgs/container/openline-trackers%2Ftracked-data-models
[emoji]: https://allcontributors.org/docs/en/emoji-key
[repo]: https://github.com/openline-ai/openline-trackers/
[slack]: https://join.slack.com/t/openline-ai/shared_invite/zt-1i6umaw6c-aaap4VwvGHeoJ1zz~ngCKQ
[sql-runner]: https://github.com/snowplow/sql-runner
[twitter]: https://twitter.com/OpenlineAI
