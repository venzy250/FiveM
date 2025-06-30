Evidence Locker by Venzy Solutions

Installation:
1. Place the 'evidence_locker' folder inside your server's resources directory.

2. Add the following to your server.cfg:
   ensure oxmysql
   ensure evidence_locker

3. Import the SQL schema into your database:
   - File: sql/schema.sql

4. Configure departments and webhooks in config.lua:
   - Each ACE group should map to a department name and Discord webhook.
   - Example:
     ["group.lspd"] = {
       name = "LSPD",
       webhook = "https://discord.com/api/webhooks/xxxxx"
     }

5. Assign ACE permissions to your server.cfg:
   add_ace group.lspd evidence.access allow
   add_ace group.bcso evidence.access allow
   add_ace group.sast evidence.access allow
   add_ace group.sahp evidence.access allow
   add_ace group.fib evidence.access allow
   add_ace group.admin evidence.admin allow

Usage:
- In-game, walk near the locker coordinates defined in config.lua.
- Press [E] to open the Evidence Locker panel.
- Select your department.
- Use the panel to:
   • View and search submitted evidence
   • Submit new entries (with officer/suspect/item details)
   • Delete evidence (if allowed)
   • Export logs to clipboard (admin only)

Features:
- Fully standalone: no ESX/QB dependency
- Clean NU
