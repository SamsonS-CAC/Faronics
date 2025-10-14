:: Windows 10 Extended Security Updates (ESU) MAK Key Batch Commands.     ::
:: Note: ESU will not work with KMS Server. Converts to MAK client first. ::
:: Critical: Windows 10 must be 22H2 and fully updated or this will fail. ::
::------------------------------------------------------------------------::

:: Get Existing Windows 10 Licence Activation info. ::
::--------------------------------------------------::
cscript.exe c:\windows\system32\slmgr.vbs /dlv 

:: After this, insert additional commands in your RMM tool to  ::
:: complete the script with your unique MAK Keys for ESU       ::
::-------------------------------------------------------------::

