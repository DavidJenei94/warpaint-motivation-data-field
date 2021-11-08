import Toybox.Application;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Math;

class Motivation {

    public var font as Number;

	private var _fontBase as Integer;

    private var _motivation as String;
    private var _splittedMotivationalQuote as String;

    private var _isMotivationalQuoteSet as Boolean;
    private var _firstLineWidthPercent as Number;
    private var _secondLineWidthPercent as Number;
    private var _thirdLineWidthPercent as Number;

    private var hardcodedMotivationalQuotesBasic = [
		"I DIDN'T COME THIS FAR TO ONLY COME THIS FAR",
		"PAIN IS TEMPORARY, BUT GREATNESS LASTS FOREVER",
		"IF IT WAS EASY EVERYBODY WOULD DO IT",
		"DON'T WAIT FOR THE OPPORTUNITY, CREATE IT",
		"IT NEVER GETS EASIER, YOU JUST GET BETTER",
		"NEVER FORGET WHY YOU STARTED",
		"GO HARD OR GO HOME",
		"BE THE BEST YOU CAN BE",
		"YESTERDAY YOU SAID TOMORROW",
		"I'M NOT A SURVIVOR, I'M A WARRIOR",
		"YOU ONLY FAIL WHEN YOU STOP TRYING",
		"IT WILL BE HARD, BUT IT WILL BE WORTH IT",
		"YOU'VE COME TOO FAR TO QUIT NOW",
		"YOU WILL WISH YOU HAD STARTED TODAY",
		"WHATEVER IT TAKES",
		"NO MORE EXCUSES",
		"DISCIPLINE SEPARATES GREAT FROM AVERAGE",
		"THE HARDER I WORK, THE LUCKIER I GET",
		"HARD WORK BEATS TALENT",
		"DON'T FORGET TO APPRECIATE WHAT YOU HAVE",
		"STRUGGLE MAKES YOU STRONGER",
		"BETTER THAN YESTERDAY",
		"STAY FOCUSED ON YOUR GOAL",
		"EVERY SINGLE DAY MATTERS",
		"YOU WERE CREATED TO DO GREAT THINGS"
	];

	(:low_memory_motivation) private var hardcodedMotivationalQuotesExtra = [
		"CHAMPIONSHIP IS WON IN THE TRAINING ROOM",
		"DON'T BE AFRAID TO BE DIFFERENT",
		"TURN ON BEAST MODE",
		"NO MATTER WHAT, YOU DON'T GIVE UP",
		"NO MORE TAKING THE EASY ROAD",
		"ONLY QUITTING IS THE END",
		"NOTHING WILL BREAK ME",
		"TO GET YOUR GOAL YOU HAVE TO TAKE RISKS",
		"DISCIPLINE EQUALS FREEDOM",
		"ELIMINATE ALL THE DISTRACTIONS",
		"SACRIFICES MADE TODAY ARE GONNA PAY OFF",
		"PAIN OF DISCIPLINE OR PAIN OF REGRET",
		"BE SO GOOD NO ONE CAN IGNORE YOU",
		"IF YOU DON'T TRY, YOU WILL NEVER KNOW",
		"BECOME THE BEST VERSION OF YOU"
	];

    //! Constructor
    //! @param dc Device Content
    function initialize() {
        _isMotivationalQuoteSet = true;
    }


	//! Split the motivational quote
	//! @param dc Device Content
	//! @return motivational quote splitted with line breaks
	public function setMotivationalQuote(dc as Dc) as String {

		var isMotivationSet = false;

		var motivationFirstPart as String;
		var motivationSecondPart as String;
		var motivationThirdPart as String;

		do {
			var motivation = getRandomHardcodedMotivationalQuote();
			
			// Split automatically with spaces and length
			var motivationLength = motivation.length();
			motivationFirstPart = "";
			motivationSecondPart = "";
			motivationThirdPart = "";

			setFontSize(dc, motivation);
			var screenWidth = dc.getWidth();
			var motivationLengthInPixels = dc.getTextWidthInPixels(motivation, font);
			var maxTextLength = screenWidth * _firstLineWidthPercent + screenWidth * _secondLineWidthPercent + screenWidth * _thirdLineWidthPercent;

			var firstMiddleSpaceIndex = null;
			var secondMiddleSpaceIndex = null;
			
			if (motivationLengthInPixels <= screenWidth * _secondLineWidthPercent * 0.95) {
				isMotivationSet = true;
				motivationFirstPart = motivation;
			} else if (motivationLengthInPixels <= maxTextLength) {
				isMotivationSet = true;
				// split text at 0.50 and 1.00 and find first spaces
				// if not found it goes back with some characters
				var firstSplitPart = 0.49;
				var secondSplitPart = 1.00;
				
				do {
					motivationSecondPart = motivation.substring(Math.ceil(motivationLength * firstSplitPart), motivationLength); 
					firstMiddleSpaceIndex = motivationSecondPart.find(" ");
					if (firstMiddleSpaceIndex != null) {
						firstMiddleSpaceIndex = motivationSecondPart.find(" ") + Math.ceil(motivationLength * firstSplitPart);
						motivationFirstPart = motivation.substring(0, firstMiddleSpaceIndex);
					}

					firstSplitPart -= 0.03;
					if (firstSplitPart < 0) {
						break;
					}
				} while (dc.getTextWidthInPixels(motivationFirstPart, font) >= screenWidth * _firstLineWidthPercent || firstMiddleSpaceIndex == null);
				
				do {
					motivationThirdPart = motivation.substring(Math.ceil(motivationLength * secondSplitPart), motivationLength);
					secondMiddleSpaceIndex = motivationThirdPart.find(" ");
					if (secondMiddleSpaceIndex != null) {	    	
						secondMiddleSpaceIndex = motivationThirdPart.find(" ") + Math.ceil(motivationLength * secondSplitPart);
						motivationThirdPart = motivation.substring(secondMiddleSpaceIndex + 1, motivationLength); //+1 to skip the space at the start of it 
						
						motivationSecondPart = motivation.substring(firstMiddleSpaceIndex + 1, secondMiddleSpaceIndex);
					} else if (firstMiddleSpaceIndex != null) {
						//motivationThirdPart remains empty
						motivationThirdPart = "";
						motivationSecondPart = motivation.substring(firstMiddleSpaceIndex + 1, motivationLength);
					} else {
						isMotivationSet = false;
						break;	
					}

					secondSplitPart -= 0.03;
					if (secondSplitPart < 0) {
						break;
					}
				} while (dc.getTextWidthInPixels(motivationSecondPart, font) >= screenWidth * _secondLineWidthPercent);
				
				firstSplitPart = (firstSplitPart * 100).toNumber();
				secondSplitPart = (secondSplitPart * 100).toNumber();
				if (firstSplitPart == secondSplitPart || (dc.getTextWidthInPixels(motivationThirdPart, font) >= screenWidth * _thirdLineWidthPercent)) {
					isMotivationSet = false;				
				}
			} else {
				isMotivationSet = false;
			}

			if (!isMotivationSet) {
				System.println("Failed motivation: " + motivationFirstPart + " " + motivationSecondPart + " " + motivationThirdPart);
			}
		} while (!isMotivationSet);

		if (motivationSecondPart.equals("")) {
			return motivationFirstPart;
		} else if (motivationThirdPart.equals("")) {
			return motivationFirstPart + "\n" + motivationSecondPart;
		} else {
			return motivationFirstPart + "\n" + motivationSecondPart + "\n" + motivationThirdPart; 
		}  
	}


	//! Get a random motivational quote 
	//! @return a random quote from the list hard coded
	private function getRandomHardcodedMotivationalQuote() as String {
		if (lowMemory) {
			var randomIndex = Math.rand() % hardcodedMotivationalQuotesBasic.size();
			return hardcodedMotivationalQuotesBasic[randomIndex];
		} else {
			var randomIndex = Math.rand() % (hardcodedMotivationalQuotesBasic.size() + hardcodedMotivationalQuotesExtra.size());
			var hardcodedMotivationalQuotesAll = [];
			hardcodedMotivationalQuotesAll.addAll(hardcodedMotivationalQuotesBasic);
			hardcodedMotivationalQuotesAll.addAll(hardcodedMotivationalQuotesExtra);
			return hardcodedMotivationalQuotesAll[randomIndex];
		}
	}

	public function setFontBase(fontBase as Integer) as Void {
		_fontBase = fontBase;
	}

	private function setFontSize(dc as Dc, motivation as String) as Void {
		var screenWidth = dc.getWidth();
    	var motivationLengthInPixels = 0;
    	var maxTextLength = screenWidth * _firstLineWidthPercent + screenWidth * _secondLineWidthPercent + screenWidth * _thirdLineWidthPercent;
	
		// _fontBase 4->0
		for (var iFont = _fontBase; iFont >= 0; iFont--){
			motivationLengthInPixels = dc.getTextWidthInPixels(motivation, iFont);
			maxTextLength = 0.75 * (screenWidth * _firstLineWidthPercent + screenWidth * _secondLineWidthPercent + screenWidth * _thirdLineWidthPercent);
			if (motivationLengthInPixels < maxTextLength) {
				font = iFont;
				return;
			} 
		}

		font = 0;
	}

	public function setLineWidths(firstLineWidth as Number, secondLineWidth as Number, thirdLineWidth as Number) as Void {
		_firstLineWidthPercent = firstLineWidth;
        _secondLineWidthPercent = secondLineWidth;
        _thirdLineWidthPercent = thirdLineWidth;
	}
}
