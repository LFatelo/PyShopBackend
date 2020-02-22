
USE WebDB;

DECLARE @authorid SMALLINT, @book_prod_type SMALLINT, @prod_id INT

EXEC AddClient 'abc@abg.com', --'$2b$12$BIQwDi5pXpSMARI9gvuY0.iPT7pU6YGv4lpQKxkdbIdJqP8Mhpp8K', -- 'abcabc' c/ sal, 
     'abC123!', 'Arnaldo', 'Amaral', '939735531', 'Av. dos Estados Unidos da América, n. 2, 10 A Lisboa',
     '1950023', 'PT', '1985-02-02',
     '216398921'

EXEC AddClient 'teste23189@gmail.com', 
     'abC123!',  -- 'abC123!' c/ sal
     'Alberto', 
     'Alves', '919734539', 'Av. Brasil, n. 2, 10 A Lisboa',
     '1750023', 'PT', '1982-02-02',
     '217398145'

EXEC AddClient 'testeABCDE@gmail.com', 
     'Abc123!', -- 'Abc123!' c/ sal
     'Armando', 
     'Antunes', '219734539', 'Av. Forças Armadas, n. 2, 10 A Lisboa',
     '1758023', 'PT', '1978-12-02',
     '217298141'

EXEC AddAuthor 'Eric Mathes',
	'Eric Mathes',
	'1972-04-25',
	'Guru do Python'

EXEC AddAuthor 'John V. Guttag',
	'John Viking Guttag',
	'1969-10-18',
	'Guru do C#'

EXEC AddAuthor 'Al Sweigart',
	'Al Sweigart',
	'1961-10-15',
	'Guru da automatização'

EXEC AddAuthor 'Henrique Loureiro',
	'Henrique Loureiro',
	'1981-04-25',
	'Professor de programação'

SELECT * FROM Product_Type
SELECT @book_prod_type= id FROM Product_Type WHERE name = 'book';
SELECT @authorid = id FROM Author WHERE name = 'Henrique Loureiro'
SET @prod_id = -1;


EXEC AddBook 
    @book_prod_type, 
    38.85, 
    'BKP-PTP-FCA-P.CS-9727228683',
    '9727228683', 
    0, 
    500, 
    '240/170/23',
    '
    <p class="item-desc book">
        Este livro cobre as técnicas de programação 
        associadas à linguagem C# na sua versão 7.0 totalmente integrada no Visual 
        Studio. A obra encontra-se estruturada de forma a facilitar a aprendizagem 
        e a apoiar os leitores na progressão das matérias. Possui uma vasta 
        componente prática, composta por exercícios resolvidos, exercícios propostos
        e cinco projetos integralmente resolvidos, que contemplam as mais recentes 
        tecnologias de desenvolvimento para ambientes Windows (Windows Forms, 
        Windows Presentation Foundation e Universal Windows Platform), para a Web 
        (ASP.NET) e para as plataformas móveis atualmente com maior presença no 
        mercado - Android, iOS e Windows Mobile. A estrutura didática do livro e a 
        forte componente prática, que inclui ajudas à resolução dos exercícios 
        propostos e respetivas soluções em www.fca.pt, facilitam não só a 
        aprendizagem, como também a utilização desta obra no dia a dia. Torna-se, 
        assim, um livro imprescindível tanto para os que estão a dar os primeiros 
        passos na programação em C# (estudantes ou autodidatas), como para os 
        profissionais que já possuem conhecimentos nesta área. Por ter aplicação 
        em qualquer grau de ensino, revela-se igualmente um excelente guia 
        pedagógico para professores e formadores. É disponibilizado um glossário 
        dos principais termos técnicos para o português do Brasil e a matéria 
        tratada é compatível com todas as edições do Visual Studio, incluindo as 
        gratuitas.</p>
    ',
    'C# 7.0 com Visual Studio (FCA) - Curso Completo',
    @authorid,
    NULL,  -- author2_id
    NULL,  -- author3_id
    'Programming',
    'C#',
    'Portuguese',
    'FCA',
    '2017-07-01',
    1,
    '9727228682',
    '9789727228683',
    'paper',
    528,
    'pt_PT',
	100,

    @prod_id

SELECT @authorid = id FROM Author WHERE name = 'Eric Mathes'
SET @prod_id = -1;

EXEC AddBook 
    @book_prod_type, 
    29.50, 
    'BKH-USE-NSP-P.PY.WP-0201896834', 
    '0201896834', 
    0, 
    1089, 
    '234/178/33',
    '
    <p class="item-desc book">
        Python Crash Course is a fast-paced, thorough 
        introduction to programming with Python that will have you writing programs, 
        solving problems, and making things that work in no time.</p>
        <p class="item-desc book">In the first half of the book, you’ll learn about 
        basic programming concepts, such as lists, dictionaries, classes, and loops, 
        and practice writing clean and readable code with exercises for each topic. 
        You’ll also learn how to make your programs interactive and how to test your 
        code safely before adding it to a project. In the second half of the book, 
        you’ll put your new knowledge into practice with three substantial projects: 
        a Space Invaders–inspired arcade game, data visualizations with Python’s 
        super-handy libraries, and a simple web app you can deploy online.</p>
    <p class="item-desc book">
        As you work through Python Crash Course you’ll learn how to:
        &#8211;Use powerful Python libraries and tools, including matplotlib, NumPy, and Pygal
        &#8211;Make 2D games that respond to keypresses and mouse clicks, and that grow
        more difficult as the game progresses
        &#8211;Work with data to generate interactive visualizations
        &#8211;Create and customize Web apps and deploy them safely online
        &#8211;Deal with mistakes and errors so you can solve your own programming 
        problems.</p>
    <p class="item-desc book">
        If you’ve been thinking seriously about digging into 
        programming, Python Crash Course will get you up to speed and have you writing 
        real programs fast. Why wait any longer? Start your engines and code!</p>
    <p class="item-desc book">
        <strong>Uses Python 2 and 3</strong></p>
    ',
    'Python Crash Course: A Hands-On, Project-Based Introduction to Programming',
    @authorid,
    NULL,  -- author2_id
    NULL,  -- author3_id
    'Programming',
    'Python',
    'Hobbies & Games',
    'No Starch Press',
    '2015-11-30',
    1,
    '1593276036',
    '978-1593276034',
    'paper',
    560,
    'en_US',   
	50,
    @prod_id     

SELECT @authorid = id FROM Author WHERE name = 'John V. Guttag'
SET @prod_id = -1;

EXEC AddBook
	@book_prod_type,
	47.88, 
    'BKP-USE-MIT-P.IB.WP-0262529624',
    '0262529624', 
    0, 
    726, 
    '229/178/20',
    '
    <p class="item-desc book">
        This book introduces students with little or no prior programming experience 
        to the art of computational problem solving using Python and various Python 
        libraries, including PyLab. It provides students with skills that will 
        enable them to make productive use of computational techniques, including 
        some of the tools and techniques of data science for using computation to 
        model and interpret data. The book is based on an MIT course (which became 
        the most popular course offered through MIT’s OpenCourseWare) and was 
        developed for use not only in a conventional classroom but in in a massive 
        open online course (MOOC). This new edition has been updated for Python 3, 
        reorganized to make it easier to use for courses that cover only a subset of
        the material, and offers additional material including five new chapters.</p>
    <p class="item-desc book">
        Students are introduced to Python and the basics 
        of programming in the context of such computational concepts and techniques 
        as exhaustive enumeration, bisection search, and efficient approximation 
        algorithms. Although it covers such traditional topics as computational 
        complexity and simple algorithms, the book focuses on a wide range of topics
        not found in most introductory texts, including information visualization, 
        simulations to model randomness, computational techniques to understand data,
        and statistical techniques that inform (and misinform) as well as two 
        related but relatively advanced topics: optimization problems and dynamic 
        programming. This edition offers expanded material on statistics and machine
        learning and new chapters on Frequentist and Bayesian statistics.</p>
    ',
    'Introduction to Computation and Programming Using Python: With Application to Understanding Data (MIT Press) second edition Edition',
	@authorid,
    NULL,  -- author2_id
    NULL,  -- author3_id
    'Programming',
    'Python',
    'Introductory & Beginning',
    'MIT Press',
    '2016-08-12',
    2,
    '0262529629',
    '978-0262529624',
    'paper',
    528,
    'en_US',
	25,

    @prod_id     

SELECT @authorid = id FROM Author WHERE name = 'Al Sweigart'
SET @prod_id = -1;

EXEC AddBook 
	@book_prod_type, 
    25.50, 
    'BKP-USE-NSP-P.PY.IB-1593275990',
    '1593275990', 
    0, 
    998, 
    '231/178/30',
    '
    <p class="item-desc book">
        If you’ve ever spent hours renaming files or 
        updating hundreds of spreadsheet cells, you know how tedious tasks like 
        these can be. But what if you could have your computer do them for you?
        </p>
    <p class="item-desc book">
        In Automate the Boring Stuff with Python, you’ll learn how to use Python to 
        write programs that do in minutes what would take you hours to do by 
        hand&#8212;no prior programming experience required. Once you’ve mastered 
        the basics of programming, you’ll create Python programs that effortlessly 
        perform useful and impressive feats of automation to:</p>
        <p class="item-desc book">    
        &#8211;Search for text in a file or across multiple files
        &#8211;Create, update, move, and rename files and folders
        &#8211;Search the Web and download online content
        &#8211;Update and format data in Excel spreadsheets of any size
        &#8211;Split, merge, watermark, and encrypt PDFs
        &#8211;Send reminder emails and text notifications
        &#8211;Fill out online forms</p>
    <p class="item-desc book">
        Step-by-step instructions walk you through each 
        program, and practice projects at the end of each chapter challenge you to 
        improve those programs and use your newfound skills to automate similar tasks.</p>
        <p class="item-desc book">Don’t spend your time doing work a well-trained 
        monkey could do. Even if you’ve never written a line of code, you can make 
        your computer do the grunt work. Learn how in Automate the Boring Stuff 
        with Python.</p>
    ',
    'Automate the Boring Stuff with Python: Practical Programming for Total Beginners 1st Edition',
    @authorid,
    NULL,  -- author2_id
    NULL,  -- author3_id
    'Programming',
    'Python',
    'Web Programming',
    'No Starch Press',
    '2015-04-14',
    1,
    '1593275994',
    '978-1593275990',
    'paper',
    504,
    'en_US',
	10,

    @prod_id
	
DECLARE @elec_prod_type INT
SELECT @elec_prod_type = id FROM Product_Type WHERE name = 'electronic';
SELECT @elec_prod_type

EXEC AddElectronic
	@elec_prod_type, 
    1129, 
    'ELCL-APP-MBA13/1.6/8/128-MLH72LL/A',
    0, 
    1350, 
    '325/227/17', 
    '
    <ul clas="item-desc book">
        <li>802.11ac Wi-Fi wireless networking5; IEEE 802.11a/b/g/n compatible</li>
        <li>Powered by fifth-generation Intel Core i5 processor. This ultra-efficient 
        architecture was designed to use less power and still deliver high performance
        <li>1.6 GHz dual-core Intel Core i5 (Turbo Boost up to 2.7 GHz) with 3 MB 
           shared L3 cache, 8GB of 1600MHz LPDDR3 onboard memory, 128GB PCIe-based 
           flash storage</li>
        <li>Designed entirely around flash storage. Not only does this make MacBook Air 
        much lighter and more portable than traditional notebooks, it also provides 
        access to data.</li>
        <li> With a Thunderbolt 2 port that’s twice as fast as the previous generation, 
        you can connect your MacBook Air to the latest devices and displays, like the 
        Apple Thunderbolt Display.</li>
    </ul>
    ',
    'Apple MacBook Air 13.3-Inch Laptop (Intel Core i5 1.6GHz, 128GB Flash, 8GB RAM, OS X El Capitan)',
    'MMGF2LL/A',
    '
    Screen Size=13.3 inches
    Max Screen Resolution=1440x900
    Processor=1.8 GHz Intel Core i5
    RAM=8 GB DDR3 SDRAM
    Hard Drive=128 GB SSD
    Graphics=Intel HD Graphics 6000, integrated graphics card
    Networking=WiFi 802.11ac/a/b/g/n, Bluetooth 4.0
    Interfaces=2xUSB3.0, 1xThunderBolt 2 (3.5mm)
    Camera=Facetime HD 720p/5MP
    Operating System=macOS Sierra
    Battery Life=12 hours
    Turbo Boost=2.9 GHz
    CPU Cache=3 MB
    ',
    '2015-09-28',
	5,
    @prod_id

EXEC AddElectronic
    @elec_prod_type, 
    1199, 
    'ELCL-APP-MBA13/1.6/8/256-MMGG2LL/A',
    0, 
    1350,
    '325/227/17',
    '
    <ul class="item-desc book">
        <li>OS X El Capitan, Up to 12 Hours of Battery Life Macbook Air does not have a Retina 
        display on any model. </li>
        <li>802.11ac Wi-Fi wireless networking5; IEEE 802.11a/b/g/n compatible</li>
        <li>Powered by fifth-generation Intel Core i5 processor. This ultra-efficient 
        architecture was designed to use less power and still deliver high performance
        <li>1.6 GHz dual-core Intel Core i5 (Turbo Boost up to 2.7 GHz) with 3 MB 
           shared L3 cache, 8GB of 1600MHz LPDDR3 onboard memory, 256GB PCIe-based 
           flash storage</li>
        <li>Designed entirely around flash storage. Not only does this make MacBook Air 
        much lighter and more portable than traditional notebooks, it also provides 
        access to data.</li>
        <li> With a Thunderbolt 2 port that’s twice as fast as the previous generation, 
        you can connect your MacBook Air to the latest devices and displays, like the 
        Apple Thunderbolt Display.</li> 
        <li>Introduced in Early 2015 </li>
    </ul>
    ',
    'New Apple MMGG2LL/A MacBook Air 13.3-Inch Laptop (1.6 GHz Intel Core i5, 8GB RAM, 256GB SSD, Mac OS X V10.11 El Capitan), Silver',
    'MMGG2LL/A',
    '
    Screen Size=13.3 inches
    Max Screen Resolution=1440x900
    Processor=1.6 GHz Intel Core i5
    RAM=8 GB DDR3 SDRAM
    Hard Drive=256 GB SSD
    Graphics=Intel HD Graphics 6000, integrated graphics card
    Networking=WiFi 802.11ac/a/b/g/n, Bluetooth 4.0
    Interfaces=2xUSB3.0, 1xThunderBolt 2, Jack 3.5mm
    Camera=Facetime HD 720p/5MP
    Operating System=macOS Sierra
    Battery Life=12 hours
    Turbo Boost=2.7 GHz
    CPU Cache=3 MB
    ',
    '2016-04-28',
	7,
    @prod_id     
	
EXEC AddElectronic
    @elec_prod_type, 
    705.45, 
    'ELMP-APP-IP7/128/12/4.7/BM/IO10-A1660',    -- BM -> BLACK MATE
    0, 
    138, 
    '138/67/7',
    '
    <p class="item-desc elec">
        <strong>This is iPhone 7<strong></p>
    <p class="item-desc elec">
        iPhone 7 dramatically improves the most important aspects of the 
        iPhone experience. It introduces advanced new camera systems. The best 
        performance and battery life ever in an iPhone. Immersive stereo 
        speakers. The brightest, most colorful iPhone display. Splash and water 
        resistance*. And it looks every bit as powerful as it is. This is iPhone 7.</p>
    <p class="item-desc elec">
        The latest iPhone with advanced camera, better battery life, 
        immersive speakers and water resistance!</p>
    ',
    'Apple iPhone 7 128GB (Black Mate)',
    'A1660',
    '
    Screen Size=4.7 in
    Screen Specs=Retina HD Display 1334x750px    
    Camera Description=12 MP 2nd-generation Sony Exmor RS
    Internal Memory=128 GB
    RAM=2 GB LPDDR4 
    Networking=2G GSM, 3G HSDPA, 4G LTE, WiFi 802.11ac/a/b/g/n,Bluetooth 4.2
    CPU=Apple A10 Fusion 64bit, Quad-core, L1 64KB + 64KB / core, L2 3MB, L3 4MB
    GPU=PowerVR Series 7XT GT7600 (Hexa-core)
    Operating System=iOS 10.0
    Card=Nano SIM
    Battery Life=14 hours conversation, 50 hours music, 13 hours video
    Locked=No
    ',
    '2016-09-16',
	8,
    @prod_id

EXEC AddElectronic
    @elec_prod_type, 
    819, 
    'ELMP-APP-IP7P/128/12/5.5/BM/IO10-A1661',   -- BM -> BLACK MATE, IP7P -> iPhone 7 Plus
    0, 
    188, 
    '158/78/7',
    '
    <p class="item-desc elec">
        <strong>This is iPhone 7<strong></p>
    <p class="item-desc elec">
        iPhone 7 dramatically improves the most important aspects of the 
        iPhone experience. It introduces advanced new camera systems. The best 
        performance and battery life ever in an iPhone. Immersive stereo 
        speakers. The brightest, most colorful iPhone display. Splash and water 
        resistance*. And it looks every bit as powerful as it is. This is iPhone 7.</p>
    <p class="item-desc elec">
        The latest iPhone with advanced camera, better battery life, 
        immersive speakers and water resistance!</p>
    ',
    'Apple iPhone 7 Plus - 128GB (Black Mate)',
    'A1661',
    '
    Screen Size=5.5 in
    Screen Specs=Retina HD Display 1920x1080px    
    Camera Description=12 MP 2nd-generation Sony Exmor RS
    Internal Memory=128 GB
    RAM=3 GB LPDDR4 
    Networking=2G GSM, 3G HSDPA, 4G LTE, WiFi 802.11ac/a/b/g/n,Bluetooth 4.2
    CPU=Apple A10 Fusion 64bit, Quad-core, L1 64KB + 64KB / core, L2 3MB, L3 4MB
    GPU=PowerVR Series 7XT GT7600 (Hexa-core)
    Operating System=iOS 10.0
    Card=Nano SIM
    Battery Life=21 hours conversation, 60 hours music, 14 hours video
    Locked=No
    ',
    '2016-09-16',
	4,
    @prod_id

EXEC AddElectronic
    @elec_prod_type, 
    820, 
    'ELMP-SAM-S8/64/12/5.8/MB/A7-SMG950FZ',     -- MB -> MIDNIGHT BLACK
    0, 
    152, 
    '149/68/8',
    '
    <p class="item-desc elec">
        Latest Galaxy phone with Infinity Display, Duel Pixel 
        Camera, iris scanning and Ip68-rated water and dust resistance. The phone comes 
        with a stunning 5.8" Quad HD+ Super AMOLED display (2960x1440) with 570 ppi 
        and worlds first 10nm processor.</p> 
    <p class="item-desc elec">
        <strong>Meet the Galaxy S8+ - Infinitely Brilliant.</strong></p>
    <p class="item-desc elec">
        The Galaxy S8+ has the world’s 
        first Infinity Screen, A screen without limits. The expansive display 
        stretches from edge to edge, giving you the most amount of screen in the 
        least amount of space.</p> 
    <p class="item-desc elec">        
        The revolutionary design of the Galaxy S8+ begins from the inside out. 
        We rethought every part of the phone’s layout to break through the confines 
        of the smartphone screen. So all you see is pure content and no bezel. It’s 
        the biggest, most immersive screen on a Galaxy smartphone of this size. 
        And it’s easy to hold in one hand. The Infinity Display has an incredible 
        end-to-end screen that spills over the phone’s sides, forming a completely 
        smooth, continuous surface with no bumps or angles. It’s pure, pristine, 
        uninterrupted glass. And it takes up the entire front of the phone, flowing 
        seamlessly into the aluminum shell. The result is a beautifully curved, 
        perfectly symmetrical, singular object. Capture life as it happens with the 
        Galaxy S8+ cameras. The 12MP rear camera and the 8MP front camera are so 
        accurate and fast that you won’t miss a moment, day or night. Prying eyes 
        are not a problem when you have iris scanning on the Galaxy S8+. No two 
        irises have the same pattern, not even yours, and they’re nearly impossible 
        to replicate. That means with iris scanning, your phone and its contents 
        open to your eyes only. And when you need to unlock really fast, face 
        recognition is a handy option. You never really stop using your phone. 
        That’s why Galaxy S8+ is driven by the world’s first 10nm processor. It’s 
        fast and powerful and increases battery efficiency. Plus, there’s the 
        ability to expand storage, and to work through rain and dust with IP68-rated 
        performance.</p>        
    ',    
    'Samsung Galaxy S8 Unlocked 64GB (Midnight Black)',
    'SMG950FZ',
    '
    Screen Size=5.8 in
    Screen Specs=2960x1440px 1440p SuperAMOLED QHD+ multi-touch
    Camera Description=12MP
    Internal Memory=64 MB
    RAM=4 GB LPDDR4X
    Networking=2G GSM, 3G HSDPA, 4G LTE, WiFi 802.11ac/a/b/g/n,Bluetooth 4.2, Direct Hotspot
    CPU=Exynos Octa-core, 64 bit, 10nm processor
    GPU=Exynos Mali-G71 MP20
    Operating System=Android 7.0
    Card=Nano SIM
    Battery Life=18 hours conversation, 50 hours music, 78 hours video
    Locked=No
    ',
    '2017-04-28',
	4,
    @prod_id

EXEC AddElectronic
    @elec_prod_type, 
    39.99, 
    'ELWS-WTE-DOSSBT40/BT40/W-SC1872',
    0, 
    454, 
    '76/191/51', 
    '
    <p class="item-desc elec">
        <strong>About DOSS SoundBox<strong></p>
    <p class="item-desc elec">
        At first glance, you may underestimate the quality of such a compact speaker.
        The true appeal of DOSS SoundBox 12 Watt speakers lies in its ability to deliver 
        full sound with dramatically deeper bass. Its portability, long-lasting 
        battery, and metallic design makes it the perfect audio companion for both 
        indoor and outdoor. Music are words unspoken and DOSS SoundBox translates 
        these words beautifully to our ears.</p>
    <p class="item-desc elec">
        <strong>About DOSS<strong></p>
    <p class="item-desc elec">
        With 18 years of innovation and World-wide design team from United States, 
        Canada and Germany, DOSS remains competitive in the audio Industry as a 
        professional all over the world. We are a well-established manufacturer who 
        develops the most cutting edge audio technology as well as owning exclusive 
        tooling. In addition to creating state of the art audio technology, we pride 
        ourselves in ensuring customer experience. Our business model has enabled us 
        to decrease on cost that allows our premium quality products to be marketed 
        at a competitive price.</p>
    <p class="item-desc elec">
        <strong>Sensitive Touch, Elegant Control<strong></p>
    <p class="item-desc elec">
        Sensitive touch button with Laser Carving finish. Easily switch between your 
        3 options of how to play your SoundBox (Bluetooth, Micro SD, Aux-In).</p>
    <p class="item-desc elec">
        Control your music with our elegant controls. The simple touch system at the 
        top allows you to Play, Pause, or Skip your music at your leisure as well as 
        answering phone calls.</p>
    <p class="item-desc elec">
        Adjust the volume in style with the top ring of the speaker. Clockwise rotation 
        to increase the volume and counter-clockwise to decrease.</p>
    ',
    'DOSS Touch Wireless Bluetooth V4.0 Portable Speaker with HD Sound and Bass (Black)',
    'SoundBox BT 4.0',
    NULL,
    NULL,
	8,
    @prod_id

EXEC AddElectronic
    @elec_prod_type, 
    35.70, 
    'ELMB-RASP-PI3B/1.2/1/4U2-RASPBERRYPI3MODB-GB',   -- 4U -> 4xUSB2.0
    0, 
    136, 
    '121/76/33', 
    '
    <p class="item-desc elec">
        Built on the latest Broadcom 2837 ARMv8 64 bit processor the Raspberry 
        Pi 3 Model B is faster and more powerful than its predecessors. 
        It has improved power management to support more powerful external 
        USB devices and now comes with built-in wireless and Bluetooth connectivity. 
        To take full advantage of the improved power management on the 
        Raspberry Pi 3 and provide support for even more powerful devices on the 
        USB ports, a 2.5A adapter is required.</p>
    ',
    'Raspberry PI 3 Model B A1.2GHz 64-bit quad-core ARMv8 CPU, 1GB RAM',
    'RASPBERRYPI3-MODB-1GB',
    '
    CPU=Broadcom BCM2837 ARMv8 64-bit Quad Core, 1.2 GHz
    RAM=1 GB
    Networking=BCM43143 WiFi 802.11b/g,Bluetooth 4.1
    Voltage=5 V
    Intefaces=4xUSB 2.0, 1xEthernet 1Gbps, 40pin GPIO, Camera CSI, Display DSI
    Display Connectivity= 1xFull HDMI
    Card Reader=Micro SD    
    ',
    NULL,
	3,
    @prod_id

	INSERT INTO Campaign 
		(title, start_date, end_date) 
	VALUES 
		('<span><strong>black friday</strong> 2016</span> <span class="invert">deals</span>',
		 DATEADD(DAY, -30, GETDATE()),
		 DATEADD(DAY, -25, GETDATE()));

	INSERT INTO Campaign 
		(title, start_date, end_date) 
	VALUES 
		('<span><strong>christmas</strong> 2016</span> <span class="invert">deals</span>',
		 DATEADD(DAY, -10, GETDATE()),
		 DATEADD(DAY, 10, GETDATE()));

EXEC AddOrder
	10001,
	'R. do Bacanal',
	420,
	'OC',
	NULL,
	NULL,
	NULL,
	NULL,
	'IP',
	'No'

EXEC AddOrder
	10003,
	'R. do Cet',
	666,
	'OC',
	NULL,
	NULL,
	NULL,
	NULL,
	'IP',
	'No'

EXEC AddOrder_Item
	100001,
	100002,
	5,
	'IVA',
	NULL

EXEC AddOrder_Item
	100001,
	100011,
	5,
	'IVA',
	NULL

EXEC AddOrder_Item
	100002,
	100008,
	5,
	'IVA',
	NULL

