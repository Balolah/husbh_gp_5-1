using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using ArabicSupport;

public class MultiplicationMathProblem: MonoBehaviour {
  // Start is called before the first frame update
 public GameObject questionBox;
  public string text;
  public Text firstNumber;
  // public Text operator;
  public Text secondNumber;
  public Text answer1;
  public Text answer2;
  public Text answer3;
  public Text answer4;
  public Text operatorr;

  public List < int > easyMathList = new List < int > ();

  public int randomFirstNumber;
  public int randomSecondNumber;
  // here to make the question go in levels 
  
  public int  levelQ =0;
  int firstNumberInProblem;
  int secondNumberInProblem;
  int answerOne;
  int answerTwo;
  int answerThree;
  int answerFour;
  int displayRandomAnswer;
  int randomAnswerPlacement;
  public int currentAnswer;
  public Text rightOrWrong_Text;
  public int count = 12; //اذا طلعت 12 اسئلة يوقف
  public GameObject GameExplain;
  public Text exaplain;
  //Scoring (counter)
  public GameObject scoreBox;
  public int MultiplicationScore = 0;
  public Text score;
  public Text result;
  public GameObject displayWindow;

  //Result Window
  public Text completeText;
  //public Text resultScore;
  public Button replayButton;
  public Button backButton;
  public GameObject[] star;
  private int countPoints;

  public Transform stars; //filled stars depends on the score
  protected
  const int fillStars = 100 / 3; //calculate how much we fill the star depends on the score
  public bool useFillAmount = false; //??
  public Text replayButtonText;
  public Text backButtonText;
 public Button cancel;
 
 public AudioSource audioDuck;
public AudioSource audioCat;
public AudioSource audioSheep;
public AudioSource audioPeng;


  private void Start() {
    answer1.enabled = false;
    answer2.enabled = false;
    answer3.enabled = false;
    answer4.enabled = false;
    questionBox.SetActive(false);
    scoreBox.SetActive(false);
    StartCoroutine(ActiveObject());
    score.text = ArabicFixer.Fix(0 + "");
    DisplayMultiplicationMathProblem();
    // countPoints =GameObject.FindGameObjectsWithTag("Points").Length;
  }

  public GameObject LevelDialog;
  public Text LevelStatus;
  public Text scoreText;
  public void ShowLevelDialog(string status, string scores) {
    GetComponent < MultiplicationMathProblem > ().starArcheived();
    LevelDialog.SetActive(true);
    LevelStatus.text = status;
    scoreText.text = scores;

  }

  //The question generator method
  public void DisplayMultiplicationMathProblem() {
    operatorr.text = ArabicFixer.Fix(" x ");
   // level1(0,1,2,3)
      
       randomFirstNumber = levelQ;


      
       //first number
   // randomFirstNumber = Random.Range(0, 10);
    // randomFirstNumber = Random.Range(0, easyMathList.Count + 1);
    //second number
    randomSecondNumber = Random.Range(0, 11);
    // randomSecondNumber = Random.Range(0, easyMathList.Count + 1);
    firstNumberInProblem = randomFirstNumber;
    secondNumberInProblem = randomSecondNumber;
    //the correct answer option is to calculate the first and second number
    answerOne = firstNumberInProblem * secondNumberInProblem;


    displayRandomAnswer = Random.Range(0, 2);
    if (displayRandomAnswer == 0) {
      answerTwo = answerOne + Random.Range(1, 3);
      answerThree = answerOne + Random.Range(4, 6);
      answerFour = answerOne + Random.Range(7, 9);
    } else {
      answerTwo = answerOne - Random.Range(1, 3);

      answerThree = answerOne - Random.Range(4, 6);

      answerFour = answerOne - Random.Range(7, 9);

      // عشان نشيل الاعداد السالبة من الخيارات
      if (answerTwo < 0) {
        answerTwo = Mathf.Abs(answerTwo);
        answerTwo = answerOne + Random.Range(1, 3);
      }
      if (answerThree < 0) {
        answerThree = Mathf.Abs(answerThree);
        answerThree = answerOne + Random.Range(4, 6);
      }
      if (answerFour < 0) {
        answerFour = Mathf.Abs(answerFour);
        answerFour = answerOne + Random.Range(7, 9);
      }
    }
    firstNumber.text = ArabicFixer.Fix("" + firstNumberInProblem);
    secondNumber.text = ArabicFixer.Fix("" + secondNumberInProblem);

    //randomization to the correct answer to be displayed in different option place everytime

    //if the place is 0, place the correct answer at place (position/index) 0 (first option)...and so on
    randomAnswerPlacement = Random.Range(0, 4);
    if (randomAnswerPlacement == 0) {
      answer1.text = ArabicFixer.Fix("" + answerOne);
      answer2.text = ArabicFixer.Fix("" + answerTwo);
      answer3.text = ArabicFixer.Fix("" + answerThree);
      answer4.text = ArabicFixer.Fix("" + answerFour);
      currentAnswer = 0;
    } else if (randomAnswerPlacement == 1) {
      answer1.text = ArabicFixer.Fix("" + answerTwo);
      answer2.text = ArabicFixer.Fix("" + answerOne);
      answer3.text = ArabicFixer.Fix("" + answerFour);
      answer4.text = ArabicFixer.Fix("" + answerThree);
      currentAnswer = 1;

    } else if (randomAnswerPlacement == 2) {

      answer1.text = ArabicFixer.Fix("" + answerThree);
      answer2.text = ArabicFixer.Fix("" + answerFour);
      answer3.text = ArabicFixer.Fix("" + answerOne);
      answer4.text = ArabicFixer.Fix("" + answerTwo);
      
      currentAnswer = 2;
    } else {
      answer1.text = ArabicFixer.Fix("" + answerThree);
      answer2.text = ArabicFixer.Fix("" + answerFour);
      answer3.text = ArabicFixer.Fix("" + answerTwo);
      answer4.text = ArabicFixer.Fix("" + answerOne);
      currentAnswer = 3;
    }

answer1.fontStyle = FontStyle.Bold;
answer2.fontStyle = FontStyle.Bold;
answer3.fontStyle = FontStyle.Bold;
answer4.fontStyle = FontStyle.Bold;
  }

  //method to calculate the score and print it on screen
  public void AddScore() {
    MultiplicationScore += 1;
    score.text = ArabicFixer.Fix("" + MultiplicationScore);
  }

  public void MessengerFlutter()
    {

        UnityMessageManager.Instance.SendMessageToFlutter("M"+MultiplicationScore);
    }

  // method to call when there is no questions to display to show the score    
  public void DisplayFinalScore() {

    //display message for excellent score   
    if (MultiplicationScore >= 8) {
      result.text = ArabicFixer.Fix("احسنت! نتيجتك: " + MultiplicationScore);
      result.color = Color.white; //green
    }

    //display message for good score
    if (MultiplicationScore >= 5 && MultiplicationScore <= 7) {
      result.text = ArabicFixer.Fix("جيد! نتيجتك: " + MultiplicationScore);
      result.color = Color.white; //yellow
    }

    //display message for bad score
    if (MultiplicationScore <= 4) {

      result.text = ArabicFixer.Fix("حاول مرة اخرى! نتيجتك: " + MultiplicationScore);
      result.color = Color.white;
    }

  backButtonText.text= ArabicFixer.Fix("عودة" );

  }
  public void starArcheived() {
    //  int starLeft = GameObject.FindGameObjectsWithTag("Points").Length;
    //  int pointsCollected = additionScore-starLeft;
    //  float percentage =float.Parse(pointsCollected.ToString())/float.Parse(additionScore.ToString())*100f;
    if (MultiplicationScore >= 1 && MultiplicationScore < 5) {
      //one star 
      star[0].SetActive(true);
    } else if (MultiplicationScore >= 5 && MultiplicationScore < 8) {
      //two stars
      star[0].SetActive(true);
      star[1].SetActive(true);
    } else if (MultiplicationScore >= 8 && MultiplicationScore <= 12) {
      //three stars
      star[0].SetActive(true);
      star[1].SetActive(true);
      star[2].SetActive(true);
    }

  }

  //option answer 1
  public void ButtonAnswer1() {
    if (currentAnswer == 0) {
      rightOrWrong_Text.enabled = true;
      rightOrWrong_Text.color = Color.green;
      rightOrWrong_Text.text = ("✔");
      answer1.fontStyle = FontStyle.Bold;
      AddScore();
      Invoke("TurnOffText", 1);
    } else {
      rightOrWrong_Text.enabled = true;
      rightOrWrong_Text.color = Color.red;
      rightOrWrong_Text.text = ("✕");
      Invoke("TurnOffText", 1);
    }
  }

  //option answer 2
  public void ButtonAnswer2() {
    if (currentAnswer == 1) {
      rightOrWrong_Text.enabled = true;
      rightOrWrong_Text.color = Color.green;
      rightOrWrong_Text.text = ("✔");
      AddScore();
      Invoke("TurnOffText", 1);
    } else {
      rightOrWrong_Text.enabled = true;
      rightOrWrong_Text.color = Color.red;
      rightOrWrong_Text.text = ("✕");
      Invoke("TurnOffText", 1);
    }
  }

  //option answer 3
  public void ButtonAnswer3() {
    if (currentAnswer == 2) {
      rightOrWrong_Text.enabled = true;
      rightOrWrong_Text.color = Color.green;
      rightOrWrong_Text.text = ("✔");
      AddScore();
      Invoke("TurnOffText", 1);
    } else {
      rightOrWrong_Text.enabled = true;
      rightOrWrong_Text.color = Color.red;
      rightOrWrong_Text.text = ("✕");
      Invoke("TurnOffText", 1);
    }
  }

  //option answer 4
  public void ButtonAnswer4() {
    if (currentAnswer == 3) {
      rightOrWrong_Text.enabled = true;
      rightOrWrong_Text.color = Color.green;
      rightOrWrong_Text.text = ("✔");
      AddScore();
      Invoke("TurnOffText", 1);
    } else {
      rightOrWrong_Text.enabled = true;
      rightOrWrong_Text.color = Color.red;
      rightOrWrong_Text.text = ("✕");
      Invoke("TurnOffText", 1);
    }
  }

  private  IEnumerator ActiveObject(){
  exaplain.text=ArabicFixer.Fix("ابحث عن المزرعة ثم قم بالضغط على الإجابة الصحيحة!");
  // waite for 14 
  yield return new WaitForSeconds(7);
  GameExplain.SetActive(true);
  //yield return new WaitForSeconds(1);
  GameExplain.SetActive(false);
  questionBox.SetActive(true);
  scoreBox.SetActive(true);
  answer1.enabled = true;
  answer2.enabled = true;
  answer3.enabled = true;
  answer4.enabled =true;
}

public void cancelExplain(){
StopAllCoroutines();
GameExplain.SetActive(false);
answer1.enabled = true;
answer2.enabled = true;
answer3.enabled = true;
answer4.enabled = true;
questionBox.SetActive(true);
scoreBox.SetActive(true);
}

  public void TurnOffText() {
    if (rightOrWrong_Text != null) {
      rightOrWrong_Text.enabled = false;
    }
    //decreasing the counter till 0 so no more questions to display
    count = count - 1;

    //if counter (count) of questions is not 0 yet, display questions
    if (count > 0)
      {levelQ++;
      DisplayMultiplicationMathProblem();}
    //if the counter reaches 0 (no more questions), display the score
    else {
      displayWindow.SetActive(true);
      DisplayFinalScore();
      starArcheived();
      MessengerFlutter();
    }

  }
public void playDuck() {
  audioDuck.Play();
}
public void playCat() {
  audioCat.Play();
}
public void playSheep() {
  audioSheep.Play();
}
public void playPeng() {
  audioPeng.Play();
}

}