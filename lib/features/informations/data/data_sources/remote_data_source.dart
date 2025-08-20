import 'dart:io';

import 'package:alerthub/common_libs.dart';
import 'package:alerthub/features/informations/data/model/informations/information.dart';
import 'package:alerthub/features/informations/data/model/informations/informations.dart';

import 'package:http/http.dart';

class InformationRemoteDataSource {
  Future<Informations> getInformations() async {
    try {
      // final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
      // final response = await $get('information/get_informations/$uid');

      /*   if (response.isError) {
        return Future.error(response.message);
      } */
      // return Informations.fromMap(response.data);

      return _infos;
    } on SocketException {
      return Future.error('No network connection.');
    } on ClientException {
      return Future.error('No network connection.');
    } catch (exception) {
      if (exception
          .toString()
          .contains('ClientException with SocketException')) {
        return Future.error('No network connection.');
      }
      return Future.error(exception.toString());
    }
  }
}

final _infos = Informations(data: [
  Information(
    url: '2CQpyA485wc',
    title: 'Heart Attack Emergency Response',
    id: UniqueKey().toString(),
    description: [
      'Immediately call emergency services (911 or your local emergency number) and clearly state that someone is experiencing a heart attack. Provide your exact location, the person\'s age and gender, and describe their current condition. Stay on the line and follow any instructions given by the dispatcher. If available, send someone else to call while you stay with the patient, or use speakerphone so you can continue providing care while talking to emergency services.',
      'Help the person into the most comfortable position possible, typically sitting upright with their back supported against a wall or chair, knees bent, and head and shoulders well-supported. This position helps reduce the workload on the heart and makes breathing easier. Keep them calm and reassure them that help is on the way. Do not allow them to walk around or exert themselves in any way, as this can worsen the heart attack.',
      'If the person is conscious, alert, and not allergic to aspirin, give them one adult aspirin (300-325mg) to chew slowly and completely - chewing helps the medication absorb faster into the bloodstream. Loosen any tight clothing around their neck, chest, and waist to help with breathing and circulation. If they have prescribed heart medication like nitroglycerin, help them take it as directed. Monitor their breathing, pulse, and level of consciousness continuously, and be prepared to begin CPR if they become unresponsive.',
    ],
  ),
  Information(
    url: '2CQpyA485wc',
    title: 'Choking - Heimlich Maneuver',
    id: UniqueKey().toString(),
    description: [
      'Position yourself behind the choking person and wrap your arms around their waist just above the hip bones. Make a fist with your dominant hand and place the thumb side against the person\'s abdomen, slightly above the navel but well below the breastbone. The placement is crucial - too high can damage the ribs or sternum, too low may not be effective. Ensure your fist is positioned in the soft area between the navel and the bottom of the ribcage.',
      'Grasp your fist firmly with your other hand and pull sharply inward and upward in a J-shaped motion, as if you\'re trying to lift the person off the ground. The thrust should be quick and forceful enough to create an artificial cough that will dislodge the obstruction. Each thrust should be a separate, distinct movement. Perform up to 5 abdominal thrusts, checking after each one to see if the object has been expelled from the mouth.',
      'If the abdominal thrusts are unsuccessful after 5 attempts, immediately call emergency services if not already done, and alternate between 5 back blows and 5 abdominal thrusts. For back blows, lean the person forward and strike firmly between the shoulder blades with the heel of your hand. Continue this cycle until the obstruction is cleared, the person becomes unconscious (in which case begin CPR), or emergency help arrives. If the person is pregnant or obese, use chest thrusts instead of abdominal thrusts.',
    ],
  ),
  Information(
    url: '5ksC0Yl348o',
    title: 'Severe Bleeding Control',
    id: UniqueKey().toString(),
    description: [
      'Immediately apply direct, firm pressure to the bleeding wound using the cleanest material available - ideally a sterile gauze pad, clean cloth, or towel. If nothing else is available, use your bare hands, but protect yourself from bloodborne pathogens when possible. Press down firmly and steadily, covering the entire wound area. Do not lift the covering to peek at the wound as this disrupts clot formation. The pressure should be strong enough to stop or significantly slow the bleeding - don\'t be afraid to use considerable force if the bleeding is severe.',
      'While maintaining pressure, elevate the injured area above the level of the person\'s heart if possible and if it doesn\'t cause additional pain or injury. This uses gravity to help reduce blood flow to the wound. For example, if it\'s an arm wound, have the person lie down and raise their arm up. If it\'s a leg wound, have them lie down and prop the leg up on pillows or have someone hold it elevated. Continue applying steady pressure throughout - never let up on the pressure even while elevating.',
      'If blood soaks completely through your original covering, do not remove it as this will disrupt any clots that have begun to form. Instead, add additional layers of clean material on top and continue applying pressure. If bleeding continues despite direct pressure and elevation, apply pressure to the appropriate pressure point - these are locations where major arteries run close to the surface and can be compressed against bone to reduce blood flow to the area. Common pressure points include the brachial artery (inside upper arm) for arm wounds and the femoral artery (groin area) for leg wounds. Call emergency services immediately for any severe bleeding.',
    ],
  ),
  Information(
    url: '5ksC0Yl348o',
    title: 'Unconscious Person Recovery',
    id: UniqueKey().toString(),
    description: [
      'First, check for responsiveness by tapping the person\'s shoulders firmly and shouting "Are you okay?" in a loud, clear voice. If there\'s no response, immediately check for normal breathing by looking at their chest for no more than 10 seconds - look for the rise and fall of the chest, listen for breath sounds, and feel for air movement. Do not waste time checking for a pulse as this can be unreliable and time-consuming. If the person is not breathing normally or is only gasping, begin CPR immediately. If they are breathing normally, proceed to place them in the recovery position.',
      'To place an unconscious but breathing person in the recovery position: First, kneel beside them and place the arm nearest to you at a right angle to their body with their palm facing up. Take their far arm and place the back of their hand against the cheek nearest to you, holding it there. With your other hand, grasp the far leg just above the knee and pull it up, keeping their foot flat on the ground. Pull the far leg toward you to roll them onto their side, using the leg as leverage.',
      'Once in the recovery position, tilt their head back slightly by lifting their chin to keep the airway open and prevent the tongue from blocking breathing. Adjust their hand under their cheek to keep their head tilted and stable. Bend their top leg at the knee to prevent them from rolling forward. Monitor their breathing and pulse continuously - check that they\'re still breathing normally every few minutes. If breathing stops or becomes abnormal, immediately roll them onto their back and begin CPR. Call emergency services if not already done, and be prepared to provide details about how long they\'ve been unconscious and their current condition.',
    ],
  ),
  Information(
    url: 'sQEWdOCHBxY',
    title: 'Burns - First Aid Treatment',
    id: UniqueKey().toString(),
    description: [
      'Remove the person from the heat source and cool the burn with running cold water for at least 10 minutes.',
      'Remove any jewelry or tight clothing before swelling begins, but do not remove anything stuck to the burn.',
      'Cover with a clean, dry dressing or cling film. Do not use ice, butter, or other home remedies on the burn.',
    ],
  ),
  Information(
    url: 'j_1ZpBwckA8',
    title: 'Stroke Recognition and Response',
    id: UniqueKey().toString(),
    description: [
      'Use FAST test: Face (drooping), Arms (weakness), Speech (slurred), Time (call emergency services immediately).',
      'Note the time when symptoms first appeared - this information is crucial for medical treatment decisions.',
      'Keep the person calm and comfortable. Do not give food, water, or medication. Monitor breathing and be ready to perform CPR if needed.',
    ],
  ),
  Information(
    url: 'BQjGBhC-7EI',
    title: 'Allergic Reaction - Anaphylaxis',
    id: UniqueKey().toString(),
    description: [
      'Call emergency services immediately if severe symptoms occur: difficulty breathing, swelling of face/throat, rapid pulse, or loss of consciousness.',
      'If the person has an epinephrine auto-injector (EpiPen), help them use it by injecting into the outer thigh muscle.',
      'Keep the person lying down with legs elevated. Monitor breathing and be prepared to perform CPR. Do not give anything by mouth.',
    ],
  ),
  Information(
    url: 'TGD1yLOXmC8',
    title: 'Seizure Emergency Care',
    id: UniqueKey().toString(),
    description: [
      'Keep the person safe by clearing the area of hard or sharp objects. Do not restrain them or put anything in their mouth.',
      'Turn the person onto their side to help keep the airway clear. Time the seizure - call emergency services if it lasts more than 5 minutes.',
      'Stay with the person until they recover. After the seizure, place them in recovery position and monitor their breathing closely.',
    ],
  ),
]);
