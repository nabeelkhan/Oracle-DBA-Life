-- ***************************************************************************
-- File: 15_6.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 15_6.lis

HTP.HTMLOPEN; 
   HTP.BODYOPEN('bg_image.gif', ' TOPMARGIN=5 LEFTMARGIN=5
   BGPROPERTIES=FIXEDBGCOLOR=#FFFFFF TEXT=#000000');
   HTP.PARA;
   HTP.PRINT('If you're interested in employment opportunities ' ||
      'with ' || HTF.BOLD('TUSC') || ', please contact our ' ||
      'Technical Recruiter in one of the following ways:');
   HTP.ULISTOPEN;
      HTP.LISTITEM('Attach your resume to ' || 
         HTF.ANCHOR2('mailto:recruiter@tusc.com', 'Email', NULL, 
         NULL, 'TITLE="Potential Employee"') || 'for the ' || 
         HTF.BOLD( 'TUSC') || ' Technical Recruiter');
      HTP.LISTITEM('Fax your resume to ' || HTF.BOLD('TUSC') || 
        '''s fax number below');
      HTP.LISTITEM('Mail your resume to ' || HTF.BOLD('TUSC') || 
         '''s address below');
      HTP.LISTITEM('Call ' || HTF.BOLD('TUSC') || 
         ' for more information');
      HTP.LISTITEM( 'Complete and submit the ' || 
         HTF.BOLD( 'On-Line Application Form') || 'below ');
   HTP.ULISTCLOSE;
   HTP.FONTCLOSE;
   HTP.PARA;
   HTP.HR;
   HTP.FONTOPEN(NULL, 'arial');
   HTP.BOLD('On-Line Application Form');
   HTP.BR;
   HTP.PRINT('Please tell us who you are and how you would like ' ||
      'us to make contact. When you have completed the form, ' ||
      'press the ' || HTF.ITALIC( 'Apply') || 
      ' button to send your application to ' ||
      HTF.BOLD( 'TUSC') || '. A ' || HTF.BOLD('TUSC') || 
      'representative will contact you at the first possible ' || 
      'convenience.');
   HTP.BR;
   HTP.FONTCLOSE;
   HTP.FORMOPEN( 'http://www.tusc.com/emp/plsql/register_emp', 
      'POST');
   HTP.PREOPEN;
   HTP.PRINT( 'Name: ' );
   HTP.PRINT('<INPUT NAME="Name" SIZE="50" MAXLEN="50">');
   HTP.PRINT('Address: ' );
   HTP.PRINT('<INPUT NAME="Address" SIZE=30 MAXLEN="30">');
   HTP.PRINT('<INPUT NAME="Address" SIZE=30 MAXLEN="30">');
   HTP.PRINT('City State Zip: ' ); 
   HTP.PRINT('<INPUT NAME="City" SIZE=20  MAXLEN="20">');
   HTP.PRINT('<INPUT NAME="State" SIZE="2" MAXLEN="2" >');
   HTP.PRINT('<INPUT NAME="Zip" SIZE="10" MAXLEN="10">');
   HTP.PRINT('Email Address: ' );
   HTP.PRINT('<INPUT NAME="Email" SIZE="30" MAXLEN="30">');
   HTP.PRINT('Home Page: ' );
   HTP.PRINT('<INPUT NAME="Email" SIZE="30" MAXLEN="30">');
   HTP.PRINT('Day Phone: ' );
   HTP.PRINT('<INPUT NAME="Day Phone" SIZE="20" MAXLEN="20">');
   HTP.FORMCHECKBOX('Call Day Phone');
   HTP.PRINT('Call During Day? Night Phone: ');
   HTP.PRINT('<INPUT NAME="Night Phone" SIZE="20" MAXLEN="20">');
   HTP.FORMCHECKBOX('Call Night Phone');
   HTP.PRINT('Call During Night? Who Told You About ');
   HTP.BOLD('TUSC');
   HTP.PRINT('? Referral: ');
   HTP.PRINT('<INPUT NAME="Name" SIZE="50" MAXLEN="50">');
   HTP.PRECLOSE;
   HTP.FORMHIDDEN('Form Name', 'On-Line Application');
   HTP.CENTEROPEN;
   HTP.FORMSUBMIT(NULL, 'Apply');
   HTP.FORMRESET('Clear');
   HTP.CENTERCLOSE;
   HTP.FORMCLOSE;
   HTP.HR;
   HTP.CENTEROPEN;
   HTP.BOLD('TUSC');
   HTP.BR;
   HTP.PRINT('377 E. Butterfield Road, Suite 100');
   HTP.BR;
   HTP.PRINT('Lombard, IL 60148');
   HTP.BR;
   HTP.PRINT('Phone: (630) 960-2909');
   HTP.BR;
   HTP.PRINT('Fax: (630) 960-2938');
   HTP.BR;
   HTP.PRINT('Toll Free: 1-800-755-');
   HTP.ITALIC('TUSC');
   HTP.BR;
   HTP.FONTOPEN(NULL, NULL, '1');
   HTP.PRINT('Equal Opportunity Employer');
   HTP.FONTCLOSE; 
   HTP.BR;
   HTP.CENTERCLOSE;
   HTP.HR;
   HTP.BODYCLOSE;
HTP.HTMLCLOSE;

SPOOL OFF
