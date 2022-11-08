using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using ArabicSupport;
using UnityEngine.SceneManagement;

public class AdditionMathProblem: MonoBehaviour {
  // Start is called before the first frame update

  //the gameobejct for the shooting UI
  public GameObject ShootButton;
  public GameObject ShootIcon;

  //game effects
  public GameObject arCamera;
  public GameObject smoke;

  //the question
  public GameObject questionBox;
  public string text;
  public Text firstNumber;
  public Text secondNumber;

  //the answers
  public Text answer1;
  public Text answer2;
  public Text answer3;
  public Text answer4;
  public Text operatorr;
  public List < int > easyMathList = new List < int > ();

  //the random number (int) for the question
  public int randomFirstNumber;
  public int randomSecondNumber;
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
  public int count = 12;
  public GameObject GameExplain;
  public Text exaplain; //اذا طلعت 12 اسئلة يوقف

  //the questions level 
  int LevelQ = 0;

  //Scoring (counter)
  public GameObject scoreBox;
  public int additionScore = 0;
  public Text score;

  public Text result;
  public GameObject displayWindow;

  //Result Window
  public Text completeText;
  public Button replayButton;
  public Button backButton; //& exit button
  public GameObject[] star;

  //text for the buttons 
  public Text backButtonText;
  public Button cancel;

public Button cancelshoot;
  /*
Raycast is unction that projects a Ray into the scene, returning a boolean value if a target was successfully hit.
When this happens, information about the hit, such as the distance, position or a reference to the object’s Transform.
--
RaycastHit is to detect and manipulate objects in a 3D representation of the world
 */
  public RaycastHit hit;
  public GameObject appleClicked;

  //the main
  private void Start() 
  {
    questionBox.SetActive(false);
    scoreBox.SetActive(false);
    ShootButton.SetActive(false);
    ShootIcon.SetActive(false);
    StartCoroutine(ActiveObject());
    score.text = ArabicFixer.Fix(0 + "");
    //call the method
    DisplayAdditionMathProblem();
  }

  //The question generator method
  public void DisplayAdditionMathProblem() {
    operatorr.text = ArabicFixer.Fix(" + ");
    if (LevelQ == 0) {
      randomFirstNumber = Random.Range(0, 11);
      randomSecondNumber = Random.Range(0, 10);

    }
    if (LevelQ == 1) {
      randomFirstNumber = Random.Range(0, 11);
      randomSecondNumber = Random.Range(0, 10);

    }
    if (LevelQ == 2) {
      randomFirstNumber = Random.Range(11, 21);
      randomSecondNumber = Random.Range(11, 21);

    }
    if (LevelQ == 3) {
      randomFirstNumber = Random.Range(11, 21);
      randomSecondNumber = Random.Range(11, 21);

    }
    if (LevelQ == 4) {
      randomFirstNumber = Random.Range(21, 31);
      randomSecondNumber = Random.Range(21, 31);

    }
    if (LevelQ == 5) {
      randomFirstNumber = Random.Range(21, 31);
      randomSecondNumber = Random.Range(21, 31);

    }

    if (LevelQ == 6) {
      randomFirstNumber = Random.Range(31, 41);
      randomSecondNumber = Random.Range(31, 41);

    }
    if (LevelQ == 7) {
      randomFirstNumber = Random.Range(31, 41);
      randomSecondNumber = Random.Range(31, 41);

    }

    if (LevelQ == 8) {
      randomFirstNumber = Random.Range(51, 61);
      randomSecondNumber = Random.Range(51, 61);

    }
    if (LevelQ == 9) {
      randomFirstNumber = Random.Range(61, 71);
      randomSecondNumber = Random.Range(61, 71);

    }
    if (LevelQ == 10) {
      randomFirstNumber = Random.Range(71, 81);
      randomSecondNumber = Random.Range(71, 81);

    }

    if (LevelQ == 11) {
      randomFirstNumber = Random.Range(81, 91);
      randomSecondNumber = Random.Range(81, 91);

    }

    //first number
    firstNumberInProblem = randomFirstNumber;
    //second number
    secondNumberInProblem = randomSecondNumber;

    //the correct answer option is to calculate the first and second number
    answerOne = firstNumberInProblem + secondNumberInProblem;

    while (answerOne > 250) {
      //first number
      randomFirstNumber = Random.Range(0, 250);

      //second number
      randomSecondNumber = Random.Range(0, 250);

      firstNumberInProblem = randomFirstNumber;
      secondNumberInProblem = randomSecondNumber;
      //the correct answer option is to calculate the first and second number
      answerOne = firstNumberInProblem + secondNumberInProblem;
    }

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
    additionScore += 1;
    score.text = ArabicFixer.Fix("" + additionScore);
  }
  public void MessengerFlutter()
    {

        UnityMessageManager.Instance.SendMessageToFlutter("A"+additionScore);
    }



  // method to call when there is no questions to display to show the score    
  public void DisplayFinalScore() {
    //deactivate the shoot button and icon
    ShootButton.SetActive(false);
    ShootIcon.SetActive(false);
    //display message for excellent score   
    if (additionScore >= 8) {
      result.text = ArabicFixer.Fix("احسنت! نتيجتك: " + additionScore);
      result.color = Color.white; //green
    }

    //display message for good score
    if (additionScore >= 5 && additionScore <= 7) {
      result.text = ArabicFixer.Fix("جيد! نتيجتك: " + additionScore);
      result.color = Color.white; //yellow
    }

    //display message for bad score
    if (additionScore <= 4) {
      result.text = ArabicFixer.Fix("حاول مرة اخرى! نتيجتك: " + additionScore);
      result.color = Color.white;
    }

    //the button
  backButtonText.text= ArabicFixer.Fix("عودة" );
  }

  //the stars to display
  public void starArcheived() {
     if (additionScore >= 1 && additionScore <5 ) {
      //one star 
     star[0].SetActive(true);
    } else if (additionScore >= 5 && additionScore < 8) {
      //two stars
      star[0].SetActive(true);
      star[1].SetActive(true);
    } else if (additionScore >= 8 && additionScore < 13) {
      //three stars
      star[0].SetActive(true);
      star[1].SetActive(true);
      star[2].SetActive(true);
    }
  }

  public void Shooting() {
    //check if the object is pointed from the device's camera, if yes (true) go on...
    if (Physics.Raycast(arCamera.transform.position, arCamera.transform.forward, out hit)) {
      //if the pointed object is Apple1 AND it is the right answer, shoot.
      if (hit.transform.name == "Apple1") {
        if (currentAnswer == 0) {
          //if it is correct display check mark
          rightOrWrong_Text.enabled = true;
          rightOrWrong_Text.color = Color.green;
          rightOrWrong_Text.text = ("✔");
          cancelshoot.interactable = false;
          AddScore(); //count score
          Invoke("TurnOffText", 1); //the feedback is displayed for 1 second 
          appleClicked = hit.transform.gameObject;
          appleClicked.SetActive(false);
          //use the effects
          Instantiate(smoke, hit.point, Quaternion.LookRotation(hit.normal));

        } else {
          rightOrWrong_Text.enabled = true;
          rightOrWrong_Text.color = Color.red;
          rightOrWrong_Text.text = ("✕");
          cancelshoot.interactable = false;
          Invoke("TurnOffText", 1);
          appleClicked = hit.transform.gameObject;
          appleClicked.SetActive(false);
          Instantiate(smoke, hit.point, Quaternion.LookRotation(hit.normal));
        }
      }

      //same logic goes for the rest of the method
      if (hit.transform.name == "Apple2") {
        if (currentAnswer == 1) {
          rightOrWrong_Text.enabled = true;
          rightOrWrong_Text.color = Color.green;
          rightOrWrong_Text.text = ("✔");
          cancelshoot.interactable = false;
          AddScore();
          Invoke("TurnOffText", 1);
          appleClicked = hit.transform.gameObject;
          appleClicked.SetActive(false);
          Instantiate(smoke, hit.point, Quaternion.LookRotation(hit.normal));

        } else {
          rightOrWrong_Text.enabled = true;
          rightOrWrong_Text.color = Color.red;
          rightOrWrong_Text.text = ("✕");
          cancelshoot.interactable = false;
          Invoke("TurnOffText", 1);
          appleClicked = hit.transform.gameObject;
          appleClicked.SetActive(false);
          Instantiate(smoke, hit.point, Quaternion.LookRotation(hit.normal));

        }
      }
      if (hit.transform.name == "Apple3") {
        if (currentAnswer == 2) {
          rightOrWrong_Text.enabled = true;
          rightOrWrong_Text.color = Color.green;
          rightOrWrong_Text.text = ("✔");
          cancelshoot.interactable = false;
          AddScore();
          Invoke("TurnOffText", 1);
          appleClicked = hit.transform.gameObject;
          appleClicked.SetActive(false);
          Instantiate(smoke, hit.point, Quaternion.LookRotation(hit.normal));

        } else {
          rightOrWrong_Text.enabled = true;
          rightOrWrong_Text.color = Color.red;
          rightOrWrong_Text.text = ("✕");
          cancelshoot.interactable = false;
          Invoke("TurnOffText", 1);
          appleClicked = hit.transform.gameObject;
          appleClicked.SetActive(false);
          Instantiate(smoke, hit.point, Quaternion.LookRotation(hit.normal));
        }
      }

      if (hit.transform.name == "Apple4") {
        if (currentAnswer == 3) {
          rightOrWrong_Text.enabled = true;
          rightOrWrong_Text.color = Color.green;
          rightOrWrong_Text.text = ("✔");
          cancelshoot.interactable = false;
          AddScore();
          Invoke("TurnOffText", 1);
          appleClicked = hit.transform.gameObject;
          appleClicked.SetActive(false);
          Instantiate(smoke, hit.point, Quaternion.LookRotation(hit.normal));

        } else {
          rightOrWrong_Text.enabled = true;
          rightOrWrong_Text.color = Color.red;
          rightOrWrong_Text.text = ("✕");
          cancelshoot.interactable = false;
          Invoke("TurnOffText", 1);
          appleClicked = hit.transform.gameObject;
          appleClicked.SetActive(false);
          Instantiate(smoke, hit.point, Quaternion.LookRotation(hit.normal));
        }
      }
    }
  }

//the window to explain how to play the game
  private IEnumerator ActiveObject(){
  exaplain.text=ArabicFixer.Fix("أطلق على التفاحة التي تحتوي على الاجابة الصحيحة!");
  // waite for 14 
  yield return new WaitForSeconds(7);
  GameExplain.SetActive(true);
  //yield return new WaitForSeconds(1);
  GameExplain.SetActive(false);
  ShootButton.SetActive(true);
  ShootIcon.SetActive(true);
  questionBox.SetActive(true);
  scoreBox.SetActive(true);
}

public void cancelExplain(){
StopAllCoroutines();
GameExplain.SetActive(false);
ShootButton.SetActive(true);
ShootIcon.SetActive(true);
questionBox.SetActive(true);
scoreBox.SetActive(true);
}
private IEnumerator AppleShow(){
yield return new WaitForSeconds(3);
}




public void TurnOffText() {
    if (rightOrWrong_Text != null) {
      rightOrWrong_Text.enabled = false;
    }
    //decreasing the counter till 0 so no more questions to display
    count = count - 1;

    //if counter (count) of questions is not 0 yet, display questions
    if (count > 0) {
      LevelQ++;
      // hit.transform.gameObject.SetActive(true);
      appleClicked.SetActive(true);
      cancelshoot.interactable = true;
      DisplayAdditionMathProblem();
    }
    //if the counter reaches 0 (no more questions), display the score
    else {
      displayWindow.SetActive(true);
      DisplayFinalScore();
      starArcheived();
      MessengerFlutter();
    }
  }
  
}
