Bodycam System by Venzy Solutions

Installation:
1. Place this folder in your server's resources directory
2. Add to server.cfg:
   ensure bodycam

3. Import any relevant SQL (if used) into your MySQL database

4. Configure permissions and settings in config.lua

5. Add ACE permissions:
   add_ace group.lspd leo.bodycam allow
   add_ace group.lspd leo.setunit allow
   add_ace group.lspd leo.setdistrict allow
   add_ace group.lspd iacam allow
   ... etc

Usage:
- Use /bodycam to toggle overlay
- Set unit number with /setunit
- Set district label with /setdistrict
- Recharge battery with /rechargecam
- Use /iacam and /stopcam to enter/exit IA Mode

Support:
https://venzyssolution.com
