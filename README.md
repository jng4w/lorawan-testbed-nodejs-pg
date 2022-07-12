[projectname]:  lorawan-testbed
[projectauthor]: kysudua
[linkedin]: xdtn7

<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]

--- 

<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/kysudua">
    <img src="./resources/kysudua.jpg" alt="Logo" >
  </a>

  <h3 align="center">LoRaWAN Testbed</h3>

  <p align="center">
    LoRaWAN-based IoT testbed for performance investigation.
    <br />
    <a href=""><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="">View Demo</a>
    ·
    <a href="">Report Bug</a>
    ·
    <a href="">Request Feature</a>
  </p>
</div>

---

<!-- TABLE OF CONTENTS -->
<details>
<summary><b>Table of content</b></summary>
<ol>
    <li>
      <a href="#about">About</a>
    </li>
    <li>
      <a href="#problem">Problem</a>
    </li>
    <li>
      <a href="#contact">Contact</a>
    </li>
  </ol>
</details>

---

# About

>This project proposes a LoRaWAN-based IoT testbed for performance investigation, including hardware and software components with respect to LoRaWAN network architecture specification. Additionally, the proposed testbed employs an efficient and reliable mechanism for status synchronization between a physical control device and a web-app-based control device to reduce the uplink frequency for saving power. The experimental results show that the packet loss rate is proportional to the distance between the gateway and end-devices, and is affected by building walls, obstacles, and hardware capabilities. Moreover, leveraging a network server and MQTT broker with high availability and scalability enables our proposed testbed to possibly accommodate up to 4000 users accessing the web application deployed on a server with a dual-core CPU and 2GB RAM without failure.


# Built with
## Hardware-dependent Infrastructure
|Components |Spec Descriptions |
| :---      |   :---            |
|Sensor Nodes| *Dragino LoRa/LoRaWAN end-node series* |
|Controller Nodes|*Dragino I/O controller LT-22222-L*|
|Gateway | *Dragino LPS8 Indoor LoRaWAN Gateway* |

## Network Infrastructure
|Components |Spec Descriptions |
| :---      |   :---            |
|Network Server| *The Things Stack* |

## Software-base Infrastructure
|Components |Spec Descriptions |
| :---      |   :---            |
|Application Server| *VPS (dual-core CPU, 2GB RAM)* |
|Streaming Broker| <div style="padding: 0px 6px; border: 1px solid; width:80px; height:30px;">[![EMQX][EMQX]][EMQX-url]</div>|
|Database|[![PostgreSQL][postgresql]][postgresql-url]|
|Web Server| [![NodeJS][nodejs]][nodejs-url]|
|Web Application|[![ExpressJS][Expressjs]][Expressjs-url]|
# Contact
*Duy Tinh Nguyen - [@xdtn7](https://www.linkedin.com/in/xdtn7/) - duytinhnguyenforwork@gmail.com*


<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->

[contributors-shield]: https://img.shields.io/github/contributors/kysudua/lorawan-testbed.svg?style=for-the-badge
[contributors-url]: https://github.com/kysudua/lorawan-testbed/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/kysudua/lorawan-testbed.svg?style=for-the-badge
[forks-url]: https://github.com/kysudua/lorawan-testbed/network/members
[stars-shield]: https://img.shields.io/github/stars/kysudua/lorawan-testbed.svg?style=for-the-badge
[stars-url]: https://github.com/kysudua/lorawan-testbed/stargazers
[issues-shield]: https://img.shields.io/github/issues/kysudua/lorawan-testbed.svg?style=for-the-badge
[issues-url]: https://github.com/kysudua/lorawan-testbed/issues
[license-shield]: https://img.shields.io/github/license/kysudua/lorawan-testbed.svg?style=for-the-badge
[license-url]: https://github.com/kysudua/lorawan-testbed/blob/master/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/xdtn7
[product-screenshot]: images/screenshot.png

[EMQX]: https://www.emqx.io/docs/docs-assets/img/logo-broker.da1e68d6.png
[EMQX-url]: https://www.emqx.io/docs/en/v5.0/
[postgresql]: https://img.shields.io/badge/postgreSQL-4169E1?style=for-the-badge&logo=PostgreSQL&logoColor=white
[postgresql-url]: https://www.postgresql.org/docs/10/index.html
[nodejs]: https://img.shields.io/badge/NodeJS-339933?style=for-the-badge&logo=nodedotjs&logoColor=white
[nodejs-url]: https://nodejs.org/dist/latest-v18.x/docs/api/
[Expressjs]: https://img.shields.io/badge/ExpressJS-F7DF1E?style=for-the-badge&logo=express&logoColor=black
[Expressjs-url]: https://nodejs.org/dist/latest-v18.x/docs/api/

[Next.js]: https://img.shields.io/badge/next.js-000000?style=for-the-badge&logo=nextdotjs&logoColor=white
[Next-url]: https://nextjs.org/
[React.js]: https://img.shields.io/badge/React-20232A?style=for-the-badge&logo=react&logoColor=61DAFB
[React-url]: https://reactjs.org/
[Vue.js]: https://img.shields.io/badge/Vue.js-35495E?style=for-the-badge&logo=vuedotjs&logoColor=4FC08D
[Vue-url]: https://vuejs.org/
[Angular.io]: https://img.shields.io/badge/Angular-DD0031?style=for-the-badge&logo=angular&logoColor=white
[Angular-url]: https://angular.io/
[Svelte.dev]: https://img.shields.io/badge/Svelte-4A4A55?style=for-the-badge&logo=svelte&logoColor=FF3E00
[Svelte-url]: https://svelte.dev/
[Laravel.com]: https://img.shields.io/badge/Laravel-FF2D20?style=for-the-badge&logo=laravel&logoColor=white
[Laravel-url]: https://laravel.com
[Bootstrap.com]: https://img.shields.io/badge/Bootstrap-563D7C?style=for-the-badge&logo=bootstrap&logoColor=white
[Bootstrap-url]: https://getbootstrap.com
[JQuery.com]: https://img.shields.io/badge/jQuery-0769AD?style=for-the-badge&logo=jquery&logoColor=white
[JQuery-url]: https://jquery.com 