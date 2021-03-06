/*
 * DesignerBoardAdapter.fx
 *
 * Created on Mar 17, 2009, 4:33:37 PM
 */

package net.newfoo.pig;

import javafx.animation.transition.*;
import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.CustomNode;
import javafx.scene.Node;
import javafx.scene.text.*;

import javafx.fxd.Duplicator;
import javafx.animation.Timeline;
import javafx.scene.effect.PerspectiveTransform;

/**
 * Provides an adapter for the standard UI Stubs generated from production suite.
 * The adapter makes it easier to work with designs that aren't ordered
 * optimally for a program to modify (but are ordered optimally for the designer!).
 *
 * A more robust adapter could make it easier for the rest of the game to work
 * with the design by providing a simplified and ordered interface.
 *
 * @author jconnell
 */
public class DesignerBoardAdapter extends CustomNode {
    var board = DesignerBoardUI{
    }

    public-read var gameOverDialog: Group;
    public-read var pigWinsScore: Text;
    public-read var pigWinsText: Text;
    public-read var holdButton: Group;
    public-read var playerMarker: Group;
	public-read var player1Score: Group;
    public-read var player1ScoreText: Text;
    public-read var player1Name: Group;
    public-read var player1NameText: Text;
	public-read var player2Score: Group;
    public-read var player2ScoreText: Text;
    public-read var player2Name: Group;
    public-read var player2NameText: Text;
    public-read var rollButton: Group;
    public-read var kickButton: Group;
    public-read var punchButton: Group;
	public-read var sides: Group;
    public-read var turnScore: Group;
    public-read var yesButton: Group;

    public-read var boardGroup: Group;

    init {
        rollButton = createButton(board.rollButton, board.buttonHovered, board.buttonPressed);
        kickButton = createButton(board.kickButton, board.buttonHovered, board.buttonPressed);
        punchButton = createButton(board.punchButton, board.buttonHovered, board.buttonPressed);
        holdButton = createButton(board.holdButton, board.holdHoveredButton, board.holdPressedButton);
        player1ScoreText = board.player1_digit as Text;
        player1Name = board.player_1_name as Group;
        player1NameText = board.player_1_name_text as Text;
        player2ScoreText = board.player2_digit as Text;
        player2Name = board.player_2_name as Group;
        player2NameText = board.player_2_name_text as Text;
        sides = Group {
            content: [
                board.dice1,
                board.dice2,
                board.dice3,
                board.dice4,
                board.dice5,
                board.dice6
            ]
        }
        for (node in sides.content) {
            align(board.Dice_display, node);
        }
        playerMarker = Group {
            content: [
                board.player1_active,
                board.player2_active
            ]
        }
        gameOverDialog = board.gameOverDialog as Group;
        yesButton = createButton(board.win_but_normal, board.win_but_hovered, board.win_but_pressed);
        insert yesButton into gameOverDialog.content;
        pigWinsScore = board.pig_wins_score as Text;
        pigWinsText = board.pig_wins_text as Text;

        board.Dice_display.visible = false;

        boardGroup = Group {
            content: [
                board.board,
                playerMarker,
                board.player_2_name,
                board.player_1_name,
                board.dice_table,
                board.control
                rollButton,
                kickButton,
                punchButton,
                holdButton,
                board.Dice_display,
                sides
            ]
        };

        var risingSun = TranslateTransition {
            repeatCount: Timeline.INDEFINITE
            autoReverse: true
            toY: -15
            byY: 5
            duration: 8s
            node: board.sun_dial;
        }
        risingSun.playFromStart();

        var bigNoseWiggle = SequentialTransition {
            repeatCount: Timeline.INDEFINITE
            node: board.big_pig_nose;
            content: [
                PauseTransition {
                    duration: 8s
                }
                TranslateTransition {
                    repeatCount: 4
                    autoReverse: true
                    toY: -3, byY: 1
                    toX: -3, byX: 1
                    duration: 300ms
                    node: board.big_pig_nose;
                }
            ]
        };
        bigNoseWiggle.playFromStart();

        var smallNoseWiggle = SequentialTransition {
            repeatCount: Timeline.INDEFINITE
            node: board.big_pig_nose;
            content: [
                PauseTransition {
                    duration: 6s
                }
                TranslateTransition {
                    repeatCount: 4
                    autoReverse: true
                    toY: -2.5,
                    byY: 1
                    toX: 2.5,
                    byX: 1
                    duration: 300ms
                    node: board.small_pig_nose;
                }

            ]
        };
        smallNoseWiggle.playFromStart();

    }

    public override function create(): Node {
        return Group {
            content: [
                boardGroup,
                gameOverDialog,
            ]
            // the original design is off to the side, so we need to
            // bring it into view by translating it
            translateX: -815
            translateY: -120
        };
    }

    public function rollDice( die:Node ) {
        var rotateDie = RotateTransition {
            duration: 150ms
            byAngle: 36, 
            fromAngle: 0,
            toAngle: 360
            repeatCount: 4
            node: die
        }

        rotateDie.playFromStart();
    }

    function createButton( normal:Node, hoveredSource:Node, pressedSource:Node ) {
        var hovered = Duplicator.duplicate(hoveredSource);
        align(normal, hovered);
        hovered.visible = true;
        var pressed = Duplicator.duplicate(pressedSource);
        align(normal, pressed);
        pressed.visible = true;
        var disabled = Duplicator.duplicate(normal);
        align(normal, disabled);
        var active = Duplicator.duplicate(normal);
        align(normal, active);

        replaceText(normal, hovered);
        replaceText(normal, pressed);
        Group {
            content: [
                active,
                disabled,
                pressed,
                hovered,
                normal
            ]
        }
    }

    function replaceText( text:Node, dest:Node ) {
        var group = (dest as Group);
        var newText = Duplicator.duplicate((text as Group).content[2]);
        newText.translateX = -1 * group.translateX;
        newText.translateY = -1 * group.translateY;
        (dest as Group).content[2] = newText;
    }


    function align( target:Node, dest:Node ) {
        var destBounds = dest.boundsInScene;
        var targetBounds = target.boundsInScene;
        /*
        if (dest.translateX != 0 or dest.translateY != 0) {
         println("**** Before x:{dest.translateX}: y:{dest.translateY}");
         }
         if (target.translateX != 0 or target.translateY != 0) {
         println("**** Target x:{target.translateX}: y:{target.translateY}");
         }
         println("*** Target: ({targetBounds.minX}, {targetBounds.minY})");
         */
        dest.translateX = (targetBounds.minX - destBounds.minX) - dest.translateX;
        dest.translateY = dest.translateY + (targetBounds.minY - destBounds.minY);


//        println("Translating x:{dest.translateX}: y:{dest.translateY}");


    }

}

