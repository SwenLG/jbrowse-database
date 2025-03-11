# jbrowse-database

## Registering the JBrowse Database in pgAdmin

To connect **pgAdmin** to the JBrowse database, follow these steps:

1. **Open pgAdmin** and navigate to `Servers` in the left-hand panel.
2. **Right-click** on `Servers` and select **Register > Server...**.
3. In the **General** tab:
   - Set the **Name** to: `jbrowse_config`
4. Switch to the **Connection** tab and enter the following details:
   - **Host name/address:** `postgres`
   - **Username:** `swen`
   - **Password:** `cremers`
5. Click **Save** to register the server.

Your JBrowse database should now be accessible via pgAdmin. 🎉
