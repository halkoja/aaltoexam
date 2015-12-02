classdef aaltoexam < handle
    %AALTOEXAM Generate exam arrangements for Aalto
    %   Detailed explanation goes here
    
    properties
        date;
        time;
        exams={};
        halls={};
    end
    
    methods
        function self=aaltoexam(date,time)
            self.date=date;
            self.time=time;
            
            % initialize halls: copied from math.aalto.fi/salitila
            self.add_hall('A',...
                [2	3	0	8	10
                3	5	0	8	11
                4	5	0	9	11
                5	5	0	9	12
                6	6	0	10	13
                7	6	0	10	14
                8	7	0	11	15
                9	7	0	11	16
                10	7	0	12	16
                11	8	0	12	17
                12	8	0	13	18
                13	8	0	13	19
                14	9	0	0	20
                15	9	0	8	20
                16	7	7	6	6
                17	7	9	6	6]);
            
            self.add_hall('B',...
                [2	2	8	0	2
                3	4	8	0	4
                4	4	9	0	4
                5	4	9	0	4
                6	5	10	0	5
                7	5	10	0	5
                8	5	11	0	5
                9	6	11	0	6
                10	6	12	0	6
                11	7	12	0	7
                12	7	13	0	7
                13	7	9	0	7
                14	7	7	0	7
                15	6	7	1	5]);
            
            self.add_hall('C',...
                [2		22 0
                3		22 0
                4		22 0
                5		22 0
                6		22 0
                7		22 0
                8		22 0
                9		22 0
                10		22 0
                11		22 0
                12		22 0
                13		22 0
                14	    8 8
                15	    8 0]);
            
            self.add_hall('D',...
                [2	16 0
                3	16 0
                4	16 0
                5	16 0
                6	16 0
                7	16 0
                8	16 0
                9	16 0
                10	16 0
                11	16 0
                12	16 0
                13	16 0
                14	16 0
                15	4 4
                16	4 0]);
            
            self.add_hall('E',...
                [2	16  0
                3	16  0
                4	16  0
                5	16  0
                6	16  0
                7	16  0
                8	16  0
                9	16  0
                10	16  0
                11	16  0
                12	16  0
                13	16  0
                14	16  0
                15	4	4
                16	4   0]);
  
        end
        
        function add_exam(self,oodifile)
            self.exams{end+1}=struct;
            [~,header]=system(['head ' oodifile]);
            name=strsplit(header,{'<ns1:opinkohtnim>','</ns1:opinkohtnim>'});
            name=name{2};
            code=strsplit(header,{'<ns1:opinkohttunn>','</ns1:opinkohttunn>'});
            code=code{2};
            self.exams{end}.name=[code ' ' name];
            self.exams{end}.oodifile=oodifile;
        end
        
        function viz(self)
            % visualize each hall
            for itr=1:length(self.halls)
                scount=self.count_students_in_hall(itr);
                if scount==0
                    continue
                end
                disp('-----------------------------------------------');
                disp(['Hall ',self.halls{itr}.name]);
                disp(['Total number of assigned students: ',num2str(scount)]);
                hallviz='';
                exams=containers.Map;
                for jtr=1:length(self.halls{itr}.rows)
                    hallviz=[hallviz 'Row ' self.halls{itr}.rows{jtr}.id ': '];
                    for ktr=1:length(self.halls{itr}.rows{jtr}.students)
                        hallviz=[hallviz num2str(self.halls{itr}.rows{jtr}.exam)];
                    end
                    if ~exams.isKey(num2str(self.halls{itr}.rows{jtr}.exam))
                        exams(num2str(self.halls{itr}.rows{jtr}.exam))=length(self.halls{itr}.rows{jtr}.students);
                    else
                        exams(num2str(self.halls{itr}.rows{jtr}.exam))=exams(num2str(self.halls{itr}.rows{jtr}.exam))+length(self.halls{itr}.rows{jtr}.students);
                    end
                    hallviz=[hallviz ' = ' num2str(length(self.halls{itr}.rows{jtr}.students)) '/' num2str(self.halls{itr}.rows{jtr}.space) '' sprintf('\n')];
                end
                disp(hallviz(1:(end-1)));
                for jtr=exams.keys
                    if jtr{1}~='0'
                        disp([jtr{1} ' - ' self.exams{str2num(jtr{1})}.name ', ' num2str(exams(jtr{1})) ' students' ]);
                    end
                end
            end
        end
        
        function print(self)
            disp('-----------------------------------------------');
            for itr=1:length(self.exams)
                disp(['Exam: ',self.exams{itr}.name]);
                for jtr=1:length(self.halls)
                    foundinhall=0;
                    minname='Zzz';
                    maxname='Aaa';
                    for ktr=1:length(self.halls{jtr}.rows)
                        if self.halls{jtr}.rows{ktr}.exam==itr
                            foundinhall=1;
                            for ltr=1:length(self.halls{jtr}.rows{ktr}.students)
                                try
                                    name1=sort({minname,self.halls{jtr}.rows{ktr}.students{ltr}.lastname(1:3)});
                                catch
                                    name1=sort({minname,self.halls{jtr}.rows{ktr}.students{ltr}.lastname(1:2)});
                                end
                                try
                                    name2=sort({maxname,self.halls{jtr}.rows{ktr}.students{ltr}.lastname(1:3)});
                                catch
                                    name2=sort({maxname,self.halls{jtr}.rows{ktr}.students{ltr}.lastname(1:2)});
                                end
                                minname=name1{1};
                                maxname=name2{2};
                            end
                        end
                    end
                    if foundinhall
                    	disp([self.halls{jtr}.name ' ' minname '-' maxname]);
                    end
                end
                disp(' ');
            end
        end
        
        function set_nth(self,hall,nth)
            for itr=1:length(self.halls)
                if strcmp(self.halls{itr}.name,hall)
                    self.halls{itr}.nth=nth;
                    % recompute rowspace
                    rowspace=sum(ceil(self.halls{itr}.sectors/self.halls{itr}.nth),2);
                    for jtr=1:size(rowspace,1)
                        self.halls{itr}.rows{jtr}.space=rowspace(jtr);
                    end
                    return
                end
            end
            error(['No hall ',hall,' found!'])
        end
        
        function arrange_in_halls(self,halls)
            self.read_students();
            hallids=[];
            for itr=1:length(self.halls)
                for jtr=1:length(halls)
                    if strcmp(self.halls{itr}.name,halls(jtr))
                        hallids=[hallids itr];
                    end
                end
            end
            hallids=sort(hallids);
            self.generate_seating(hallids);
        end
        
        % private methods
        function total=count_students_in_hall(self,id)
            total=0;
            for itr=1:length(self.halls{id}.rows)
                total=total+length(self.halls{id}.rows{itr}.students);
            end
        end
        
        function read_students(self)
            for itr=1:length(self.exams)
                self.exams{itr}.students={};
                % read Oodi xml file
                tree=xmlread(self.exams{itr}.oodifile);
                attendees=tree.getChildNodes.item(0).getChildNodes.item(1).getChildNodes.item(20).getChildNodes;
                N=attendees.getLength;
                % loop over students
                for jtr=1:2:N
                    student=struct;
                    student.lastname=char(attendees.item(jtr).getChildNodes.item(1).getChildNodes.item(0).getData);
                    student.id=char(attendees.item(jtr).getChildNodes.item(5).getChildNodes.item(0).getData);
                    self.exams{itr}.students{end+1}=student;
                end
            end
        end
        
        function add_hall(self,name,rows)
            self.halls{end+1}=struct;
            self.halls{end}.name=name;
            self.halls{end}.rows={};
            self.halls{end}.nth=3;
            self.halls{end}.sectors=rows(:,2:end);
            rowspace=sum(ceil(self.halls{end}.sectors/self.halls{end}.nth),2);
            for itr=1:size(rows,1)
                self.halls{end}.rows{end+1}=struct;
                self.halls{end}.rows{end}.id=num2str(rows(itr,1));
                self.halls{end}.rows{end}.space=rowspace(itr);
                self.halls{end}.rows{end}.students={};
                self.halls{end}.rows{end}.exam=0;
            end
        end
        
        function generate_seating(self,usedhalls)
            for itr=1:length(self.exams)
                notfoundcount=0;
                for jtr=1:length(self.exams{itr}.students)
                    seatfound=0;
                    for ktr=usedhalls
                        for ltr=1:length(self.halls{ktr}.rows)
                            % add only if not full row
                            if length(self.halls{ktr}.rows{ltr}.students)<self.halls{ktr}.rows{ltr}.space
                                % add student to row if exam is same or
                                % not set yet
                                if self.halls{ktr}.rows{ltr}.exam==itr || self.halls{ktr}.rows{ltr}.exam==0
                                    % check that previous or next row does
                                    % not have same exam
                                    if ltr>1
                                        checkprev=self.halls{ktr}.rows{ltr-1}.exam~=itr;
                                    else
                                        checkprev=1;
                                    end
                                    
                                    if ltr+1<=length(self.halls{ktr}.rows)
                                        checknext=self.halls{ktr}.rows{ltr+1}.exam~=itr;
                                    else
                                        checknext=1;
                                    end
                                    
                                    if ~(checkprev*checknext) % one test fails
                                        continue
                                    end
                                    
                                    % add student to row
                                    %display(['Added student ',self.exams{itr}.students{jtr}.id,' (',num2str(jtr),') to row ',self.halls{ktr}.rows{ltr}.id,' in hall ',self.halls{ktr}.name,'.']);
                                    self.halls{ktr}.rows{ltr}.students{end+1}=self.exams{itr}.students{jtr};
                                    self.halls{ktr}.rows{ltr}.exam=itr; % set row exam
                                    seatfound=1;
                                end
                            end
                            if seatfound
                                break
                            end
                        end
                        if seatfound
                            break
                        end
                    end
                    if ~seatfound
                        notfoundcount=notfoundcount+1;
                    end
                end
                if notfoundcount>0
                    warning([num2str(notfoundcount) ' students missing seats in exam ' self.exams{itr}.name '!'])
                end
            end
        end
    end
    
end

