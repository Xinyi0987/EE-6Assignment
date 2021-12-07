{

  Project: EE-6 AssignmentPart2
  Platform: Parallax Project USB Board
  Revision: 1.1
  Author: Teo Xin Yi
  Date: 1st Nov 2021
  Log:
        Date: Desc
        01/11/2021: Connect & Control Motors

}

CON
        _clkmode = xtal1 + pll16x                                               'Standard clock mode * crystal frequency = 80 MHz
        _xinfreq = 5_000_000

        ' Creating a Pause()
        _ConClkFreq = ((_clkmode - xtal1) >> 6) * _xinfreq
        _Ms_001 = _ConClkFreq / 1_000

        ' Declare Pins for Motor (Battery set on the LHS, facing floor)
        motor1 = 10 'Front left wheel
        motor2 = 11 'Front right wheel
        motor3 = 12 'Back left wheel
        motor4 = 13 'Back right wheel

        motor1Zero = 1490
        motor2Zero = 1490
        motor3Zero = 1480
        motor4Zero = 1480

VAR

  long InitCoreStack[64]
  long cog1ID

OBJ
  Motors        : "Servo8Fast_vZ2.spin"
  Term          : "FullDuplexSerial.spin"               ' UART Communication for debugging

PUB Main                                                                        'To use the functions created to run the motor

  cog1ID := cognew(Init, @InitCoreStack)                                        'To prevent multiple starts

  Forward
  TurnRight(1)
  Forward
  TurnLeft(1)
  Forward

  Reverse
  TurnLeft(2)
  Reverse
  TurnRight(2)
  Reverse

  StopAllMotors
  StopCore

PUB Init                                                                        'To start initialize code to load the motor driving code into a new core/cog

  Motors.Init
  Motors.AddSlowPin(motor1)
  Motors.AddSlowPin(motor2)
  Motors.AddSlowPin(motor3)
  Motors.AddSlowPin(motor4)
  Motors.Start
  Pause(100)                                                                    'To pause for 0.1 second

PUB StopCore                                                                    'To stop the code in the core/cog and release the core/cog

  if (cog1ID > -1)
    cogstop(cog1ID)                                                              'Stop previously launched cog

PUB Set(motorNum,speed)                                                         'To send the intended motorNum or ID and its speed

   Motors.Set(motorNum, speed)

PUB StopAllMotors                                                               'To stop all motors to its pre-set zero speed value

  Set(motor1, motor1Zero)
  Set(motor2, motor2Zero)
  Set(motor3, motor3Zero)
  Set(motor4, motor4Zero)

PUB Forward | i                                                                 'To move motor forward

  repeat i from 0 to 200 step 10                                                '5%: ((200-0)/100) * 5
    Set(motor1, motor1Zero+i)                                                   'motor 1 & 2 will turn clockwise
    Set(motor2, motor2Zero+i)
    Set(motor3, motor3Zero-i)                                                   'motor 3 & 4 will turn anti-clockwise
    Set(motor4, motor4Zero-i)
    Pause(50)
  repeat i from 200 to 0 step 10
    Set(motor1, motor1Zero+i)
    Set(motor2, motor2Zero+i)
    Set(motor3, motor3Zero-i)
    Set(motor4, motor4Zero-i)
    Pause(50)
  Pause(2000)                                                                   'stop for 2 second

PUB Reverse | i                                                                 'To move motor backward

  repeat i from 0 to 200 step 10
    Set(motor1, motor1Zero-i)                                                   'motor 1 & 2 will turn anti-clockwise
    Set(motor2, motor2Zero-i)
    Set(motor3, motor3Zero+i)                                                   'motor 3 & 4 will turn clockwise
    Set(motor4, motor4Zero+i)
    Pause(50)
  repeat i from 200 to 0 step 10
    Set(motor1, motor1Zero-i)
    Set(motor2, motor2Zero-i)
    Set(motor3, motor3Zero+i)
    Set(motor4, motor4Zero+i)
    Pause(50)
  Pause(2000)

PUB TurnLeft(mode) | i                                                          'To move motor to the left depending on the mode, mode 1 is forward mode 2 is reverse

  if (1 == mode)
    repeat i from 0 to 200 step 10
      Set(motor1, motor1Zero-i)                                                 'motor 1 & 3 will turn clockwise/ move forward
      Set(motor2, motor2Zero+i)                                                 'motor 2 & 4 will turn anti-clockwise/ reverse
      Set(motor3, motor3Zero+i)
      Set(motor4, motor4Zero-i)
      Pause(50)
    repeat i from 200 to 0 step 10
      Set(motor1, motor1Zero-i)
      Set(motor2, motor2Zero+i)
      Set(motor3, motor3Zero+i)
      Set(motor4, motor4Zero-i)
      Pause(50)
  else
    repeat i from 0 to 200 step 10
      Set(motor1, motor1Zero+i)                                                 'motors 1 & 3 will turn anti-clockwise/ move forward
      Set(motor2, motor2Zero-i)                                                 'motors 2 & 4 will turn clockwise/ reverse
      Set(motor3, motor3Zero-i)
      Set(motor4, motor4Zero+i)
      Pause(50)
    repeat i from 200 to 0 step 10
      Set(motor1, motor1Zero+i)
      Set(motor2, motor2Zero-i)
      Set(motor3, motor3Zero-i)
      Set(motor4, motor4Zero+i)
      Pause(50)
  Pause(2000)

PUB TurnRight(mode) | i                                                         'To move motor to the right depending on the mode, mode 1 is forward mode 2 is reverse

  if (1 == mode)
    repeat i from 0 to 200 step 10
      Set(motor1, motor1Zero+i)                                                 'motors 1 & 3 will turn anti-clockwise/ move forward
      Set(motor2, motor2Zero-i)                                                 'motors 2 & 4 will turn clockwise/ reverse
      Set(motor3, motor3Zero-i)
      Set(motor4, motor4Zero+i)
      Pause(50)
    repeat i from 200 to 0 step 10
      Set(motor1, motor1Zero+i)
      Set(motor2, motor2Zero-i)
      Set(motor3, motor3Zero-i)
      Set(motor4, motor4Zero+i)
      Pause(50)
  else
    repeat i from 0 to 200 step 10
      Set(motor1, motor1Zero-i)                                                 'motor 1 & 3 will turn clockwise/ reverse
      Set(motor2, motor2Zero+i)                                                 'motor 2 & 4 will turn anti-clockwise/ move forward
      Set(motor3, motor3Zero+i)
      Set(motor4, motor4Zero-i)
      Pause(50)
    repeat i from 200 to 0 step 10
      Set(motor1, motor1Zero-i)
      Set(motor2, motor2Zero+i)
      Set(motor3, motor3Zero+i)
      Set(motor4, motor4Zero-i)
      Pause(50)
  Pause(2000)
  'StopAllMotors

PRI Pause(ms) | t

  t := cnt - 1088                                       ' sunc with system counter
  repeat (ms #> 0)                                      ' delay must be > 0
    waitcnt(t += _MS_001)
  return
