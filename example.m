A=aaltoexam('21.5.2014','16:00-19:00');

A.add_exam('oodi_iso.xml',80);
A.add_exam('oodi1.xml');
A.add_exam('oodi2.xml');

A.add_exam('lady.txt',150);

% If there's no oodi file, a file called default.txt will be used.
A.add_exam({'MS-E2139','Nonlinear programming'},34);

%A.set_nth('A',5);
%A.set_nth('B',2);

%A.arrange_in_halls({'A','B','C','D','E'});
A.arrange_in_halls({'C','D'});

A.viz();

A.print();