A=aaltoexam('21.5.2014','16:00-19:00');

A.add_exam('oodi_iso.xml',80);
A.add_exam('oodi1.xml');
A.add_exam('oodi2.xml');

%A.set_nth('A',5);
%A.set_nth('B',2);

%A.arrange_in_halls({'A','B','C','D','E'});
A.arrange_in_halls({'C','D'});

A.viz();

A.print();