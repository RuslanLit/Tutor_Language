import '../curriculum/curriculum_models.dart';
import 'communicative_competency_models.dart';

class RuntimeCompetencyDefinition {
  const RuntimeCompetencyDefinition({
    required this.competency,
    required this.diagnosticTaskTemplateIds,
    required this.recoveryTemplateIds,
  });

  final CommunicativeCompetencyDefinition competency;
  final Map<String, String> diagnosticTaskTemplateIds;
  final Map<String, String> recoveryTemplateIds;
}

class CompetencyDefinitionRegistry {
  const CompetencyDefinitionRegistry({this.definitions = _defaultDefinitions});

  final List<RuntimeCompetencyDefinition> definitions;

  List<RuntimeCompetencyDefinition> definitionsForModule(String moduleId) {
    return definitions
        .where((definition) => definition.competency.moduleId == moduleId)
        .toList(growable: false);
  }

  RuntimeCompetencyDefinition? lookup({
    required String moduleId,
    required String competencyId,
  }) {
    for (final definition in definitions) {
      if (definition.competency.moduleId == moduleId &&
          definition.competency.competencyId == competencyId) {
        return definition;
      }
    }
    return null;
  }

  CommunicativeCompetencyCatalog catalogFor(
    RuntimeCompetencyDefinition definition,
  ) {
    final assessmentTasks = _assessmentTasks
        .where(
          (task) => task.competencyId == definition.competency.competencyId,
        )
        .toList(growable: false);
    return CommunicativeCompetencyCatalog(
      moduleSequence: const [
        'es.a0.m01',
        'es.a0.m02',
        'es.a0.m03',
        'es.a0.m04',
        'es.a0.m05',
        'es.a0.m06',
        'es.a0.m07',
        'es.a0.m08',
      ],
      competencies: [definition.competency],
      microCompetencies: _microCompetencies,
      assessmentTasks: assessmentTasks,
      availableRecoveryStepIds: definition.recoveryTemplateIds.values.toSet(),
    );
  }
}

const _defaultDefinitions = [
  RuntimeCompetencyDefinition(
    competency: CommunicativeCompetencyDefinition(
      competencyId: 'competency.es.a0.m03.describe_basic_personal_identity',
      moduleId: 'es.a0.m03',
      title: 'Basic personal identity check',
      communicativeGoal:
          'Exchange basic personal identity information using known patterns.',
      requiredMicroCompetencyIds: [
        'micro.es.a0.introduce_self',
        'micro.es.a0.state_origin',
        'micro.es.a0.state_residence',
        'micro.es.a0.state_languages',
        'micro.es.a0.ask_origin',
        'micro.es.a0.ask_languages',
        'micro.es.a0.build_personal_identity_profile',
      ],
      assessmentTaskIds: [
        'task.es.a0.introduce_self',
        'task.es.a0.state_origin',
        'task.es.a0.state_residence',
        'task.es.a0.state_languages',
        'task.es.a0.ask_origin_and_languages',
        'task.es.a0.build_personal_identity_profile',
      ],
    ),
    diagnosticTaskTemplateIds: {
      'task.es.a0.introduce_self':
          'template.es.a0.m03.competency.type_intro_marta.v1',
      'task.es.a0.state_origin':
          'template.es.a0.m03.competency.type_origin_ucrania.v1',
      'task.es.a0.state_residence':
          'template.es.a0.m03.competency.type_residence_kyiv.v1',
      'task.es.a0.state_languages':
          'template.es.a0.m03.competency.type_languages_ucranian_spanish.v1',
      'task.es.a0.ask_origin_and_languages':
          'template.es.a0.m03.competency.type_ask_origin_languages.v1',
      'task.es.a0.build_personal_identity_profile':
          'template.es.a0.m03.competency.type_identity_profile.v1',
    },
    recoveryTemplateIds: {
      'micro.es.a0.introduce_self':
          'template.es.a0.m02.l004.name_pattern_choice.v1',
      'micro.es.a0.state_origin': 'template.es.a0.m03.l013.origin_choice.v1',
      'micro.es.a0.state_residence':
          'template.es.a0.m03.l015.residence_choice.v1',
      'micro.es.a0.state_languages':
          'template.es.a0.m03.l016.language_choice.v1',
      'micro.es.a0.ask_origin':
          'template.es.a0.m03.l014.origin_question_choice.v1',
      'micro.es.a0.ask_languages':
          'template.es.a0.m03.l017.exchange_question_choice.v1',
      'micro.es.a0.build_personal_identity_profile':
          'template.es.a0.m03.l015.origin_residence_contrast.v1',
    },
  ),

  RuntimeCompetencyDefinition(
    competency: CommunicativeCompetencyDefinition(
      competencyId:
          'competency.es.a0.m04.describe_person_and_hold_basic_conversation',
      moduleId: 'es.a0.m04',
      title: 'People and everyday conversation check',
      communicativeGoal:
          'Describe another person and sustain a short predictable conversation.',
      requiredMicroCompetencyIds: [
        'micro.es.a0.identify_person',
        'micro.es.a0.state_person_name',
        'micro.es.a0.state_person_role',
        'micro.es.a0.describe_person_basic',
        'micro.es.a0.state_person_origin',
        'micro.es.a0.state_person_residence',
        'micro.es.a0.state_person_languages',
        'micro.es.a0.ask_about_person',
        'micro.es.a0.respond_in_everyday_exchange',
        'micro.es.a0.sustain_short_everyday_conversation',
      ],
      assessmentTaskIds: [
        'task.es.a0.m04.identify_person',
        'task.es.a0.m04.state_person_role',
        'task.es.a0.m04.describe_person_basic',
        'task.es.a0.m04.state_person_facts',
        'task.es.a0.m04.ask_about_person',
        'task.es.a0.m04.everyday_exchange',
      ],
    ),
    diagnosticTaskTemplateIds: {
      'task.es.a0.m04.identify_person':
          'template.es.a0.m04.competency.identify_person.v1',
      'task.es.a0.m04.state_person_role':
          'template.es.a0.m04.competency.state_role.v1',
      'task.es.a0.m04.describe_person_basic':
          'template.es.a0.m04.competency.describe_person.v1',
      'task.es.a0.m04.state_person_facts':
          'template.es.a0.m04.competency.person_facts.v1',
      'task.es.a0.m04.ask_about_person':
          'template.es.a0.m04.competency.ask_about_person.v1',
      'task.es.a0.m04.everyday_exchange':
          'template.es.a0.m04.competency.everyday_exchange.v1',
    },
    recoveryTemplateIds: {
      'micro.es.a0.identify_person': 'template.es.a0.m04.l020.who_choice.v1',
      'micro.es.a0.state_person_name':
          'template.es.a0.m04.l020.fill_se_llama.v1',
      'micro.es.a0.state_person_role': 'template.es.a0.m04.l021.role_choice.v1',
      'micro.es.a0.describe_person_basic':
          'template.es.a0.m04.l022.description_question_choice.v1',
      'micro.es.a0.state_person_origin':
          'template.es.a0.m03.l013.origin_choice.v1',
      'micro.es.a0.state_person_residence':
          'template.es.a0.m03.l015.residence_choice.v1',
      'micro.es.a0.state_person_languages':
          'template.es.a0.m03.l016.language_choice.v1',
      'micro.es.a0.ask_about_person':
          'template.es.a0.m04.l024.yes_no_choice.v1',
      'micro.es.a0.respond_in_everyday_exchange':
          'template.es.a0.m04.l025.dialogue_comprehension.v1',
      'micro.es.a0.sustain_short_everyday_conversation':
          'template.es.a0.m04.l025.type_short_intro.v1',
    },
  ),

  RuntimeCompetencyDefinition(
    competency: CommunicativeCompetencyDefinition(
      competencyId: 'competency.es.a0.m05.complete_basic_shopping_exchange',
      moduleId: 'es.a0.m05',
      title: 'Basic shopping exchange check',
      communicativeGoal:
          'Identify an everyday object, ask availability and price, request an item, and close a short shopping exchange.',
      requiredMicroCompetencyIds: [
        'micro.es.a0.identify_everyday_object',
        'micro.es.a0.ask_what_object_is',
        'micro.es.a0.ask_item_availability',
        'micro.es.a0.ask_price',
        'micro.es.a0.understand_price',
        'micro.es.a0.express_purchase_intention',
        'micro.es.a0.request_one_item',
        'micro.es.a0.respond_to_seller',
        'micro.es.a0.complete_basic_purchase_exchange',
      ],
      assessmentTaskIds: [
        'task.es.a0.m05.identify_object',
        'task.es.a0.m05.ask_availability',
        'task.es.a0.m05.ask_price',
        'task.es.a0.m05.understand_price',
        'task.es.a0.m05.request_item',
        'task.es.a0.m05.respond_seller',
        'task.es.a0.m05.basic_purchase_exchange',
      ],
    ),
    diagnosticTaskTemplateIds: {
      'task.es.a0.m05.identify_object':
          'template.es.a0.m05.competency.identify_object.v1',
      'task.es.a0.m05.ask_availability':
          'template.es.a0.m05.competency.ask_availability.v1',
      'task.es.a0.m05.ask_price': 'template.es.a0.m05.competency.ask_price.v1',
      'task.es.a0.m05.understand_price':
          'template.es.a0.m05.competency.understand_price.v1',
      'task.es.a0.m05.request_item':
          'template.es.a0.m05.competency.request_item.v1',
      'task.es.a0.m05.respond_seller':
          'template.es.a0.m05.competency.respond_seller.v1',
      'task.es.a0.m05.basic_purchase_exchange':
          'template.es.a0.m05.competency.basic_purchase_exchange.v1',
    },
    recoveryTemplateIds: {
      'micro.es.a0.identify_everyday_object':
          'template.es.a0.m05.l028.object_choice.v1',
      'micro.es.a0.ask_what_object_is':
          'template.es.a0.m05.l028.type_que_es_esto.v1',
      'micro.es.a0.ask_item_availability':
          'template.es.a0.m05.l029.availability_question_choice.v1',
      'micro.es.a0.ask_price':
          'template.es.a0.m05.l030.price_question_choice.v1',
      'micro.es.a0.understand_price':
          'template.es.a0.m05.l030.price_comprehension_choice.v1',
      'micro.es.a0.express_purchase_intention':
          'template.es.a0.m05.l032.request_choice.v1',
      'micro.es.a0.request_one_item': 'template.es.a0.m05.l032.fill_esta.v1',
      'micro.es.a0.respond_to_seller':
          'template.es.a0.m01.l002.type_gracias.v1',
      'micro.es.a0.complete_basic_purchase_exchange':
          'template.es.a0.m05.l033.dialogue_order_choice.v1',
      'recovery.es.a0.m05.respond_to_seller.m04':
          'template.es.a0.m04.l025.dialogue_comprehension.v1',
    },
  ),

  RuntimeCompetencyDefinition(
    competency: CommunicativeCompetencyDefinition(
      competencyId: 'competency.es.a0.m06.ask_and_follow_basic_directions',
      moduleId: 'es.a0.m06',
      title: 'Basic directions check',
      communicativeGoal:
          'Ask where a place is, ask how to get there, understand simple directions, and complete a short route exchange.',
      requiredMicroCompetencyIds: [
        'micro.es.a0.identify_transport',
        'micro.es.a0.name_transport',
        'micro.es.a0.ask_where_place_is',
        'micro.es.a0.state_place_location',
        'micro.es.a0.ask_how_to_get_somewhere',
        'micro.es.a0.understand_simple_directions',
        'micro.es.a0.give_simple_directions',
        'micro.es.a0.distinguish_left_right',
        'micro.es.a0.understand_near_far',
        'micro.es.a0.ask_which_transport',
        'micro.es.a0.state_transport_method',
        'micro.es.a0.understand_short_route_instruction',
        'micro.es.a0.respond_in_direction_exchange',
        'micro.es.a0.complete_basic_route_exchange',
      ],
      assessmentTaskIds: [
        'task.es.a0.m06.state_transport_method',
        'task.es.a0.m06.ask_where_place_is',
        'task.es.a0.m06.understand_simple_direction',
        'task.es.a0.m06.ask_how_to_get_somewhere',
        'task.es.a0.m06.give_simple_directions',
        'task.es.a0.m06.complete_route_exchange',
      ],
    ),
    diagnosticTaskTemplateIds: {
      'task.es.a0.m06.state_transport_method':
          'template.es.a0.m06.competency.state_transport_method.v1',
      'task.es.a0.m06.ask_where_place_is':
          'template.es.a0.m06.competency.ask_where_station.v1',
      'task.es.a0.m06.understand_simple_direction':
          'template.es.a0.m06.competency.understand_direction.v1',
      'task.es.a0.m06.ask_how_to_get_somewhere':
          'template.es.a0.m06.competency.ask_how_hotel.v1',
      'task.es.a0.m06.give_simple_directions':
          'template.es.a0.m06.competency.give_directions.v1',
      'task.es.a0.m06.complete_route_exchange':
          'template.es.a0.m06.competency.route_exchange.v1',
    },
    recoveryTemplateIds: {
      'micro.es.a0.identify_transport':
          'template.es.a0.m06.l036.transport_choice.v1',
      'micro.es.a0.name_transport':
          'template.es.a0.m06.l036.fill_voy_en_autobus.v1',
      'micro.es.a0.ask_where_place_is':
          'template.es.a0.m06.l037.where_question_choice.v1',
      'micro.es.a0.state_place_location':
          'template.es.a0.m06.l037.fill_esta_cerca.v1',
      'micro.es.a0.ask_how_to_get_somewhere':
          'template.es.a0.m06.l040.route_question_choice.v1',
      'micro.es.a0.understand_simple_directions':
          'template.es.a0.m06.l038.left_right_choice.v1',
      'micro.es.a0.give_simple_directions':
          'template.es.a0.m06.l038.fill_sigue_recto.v1',
      'micro.es.a0.distinguish_left_right':
          'template.es.a0.m06.l038.left_right_choice.v1',
      'micro.es.a0.understand_near_far':
          'template.es.a0.m06.l039.near_far_choice.v1',
      'micro.es.a0.ask_which_transport':
          'template.es.a0.m06.l041.transport_answer_choice.v1',
      'micro.es.a0.state_transport_method':
          'template.es.a0.m06.l041.fill_toma_metro.v1',
      'micro.es.a0.understand_short_route_instruction':
          'template.es.a0.m06.review.route_note_choice.v1',
      'micro.es.a0.respond_in_direction_exchange':
          'template.es.a0.m04.l025.dialogue_comprehension.v1',
      'micro.es.a0.complete_basic_route_exchange':
          'template.es.a0.m06.l041.transport_answer_choice.v1',
    },
  ),

  RuntimeCompetencyDefinition(
    competency: CommunicativeCompetencyDefinition(
      competencyId: 'competency.es.a0.m07.ask_for_basic_help',
      moduleId: 'es.a0.m07',
      title: 'Basic help request check',
      communicativeGoal:
          'Attract attention, ask for help, repair communication, find important services, and request urgent help in predictable situations.',
      requiredMicroCompetencyIds: [
        'micro.es.a0.get_attention_politely',
        'micro.es.a0.ask_for_help',
        'micro.es.a0.state_need_for_help',
        'micro.es.a0.state_lack_of_understanding',
        'micro.es.a0.request_repetition',
        'micro.es.a0.request_slower_speech',
        'micro.es.a0.ask_where_service_is',
        'micro.es.a0.request_medical_help',
        'micro.es.a0.request_police_help',
        'micro.es.a0.state_emergency',
        'micro.es.a0.respond_in_help_exchange',
        'micro.es.a0.complete_basic_help_exchange',
      ],
      assessmentTaskIds: [
        'task.es.a0.m07.get_attention',
        'task.es.a0.m07.ask_for_help',
        'task.es.a0.m07.repair_communication',
        'task.es.a0.m07.find_service',
        'task.es.a0.m07.request_emergency_help',
        'task.es.a0.m07.complete_help_exchange',
      ],
    ),
    diagnosticTaskTemplateIds: {
      'task.es.a0.m07.get_attention':
          'template.es.a0.m07.competency.get_attention.v1',
      'task.es.a0.m07.ask_for_help':
          'template.es.a0.m07.competency.ask_for_help.v1',
      'task.es.a0.m07.repair_communication':
          'template.es.a0.m07.competency.repair_communication.v1',
      'task.es.a0.m07.find_service':
          'template.es.a0.m07.competency.find_service.v1',
      'task.es.a0.m07.request_emergency_help':
          'template.es.a0.m07.competency.request_emergency_help.v1',
      'task.es.a0.m07.complete_help_exchange':
          'template.es.a0.m07.competency.complete_help_exchange.v1',
    },
    recoveryTemplateIds: {
      'micro.es.a0.get_attention_politely':
          'template.es.a0.m07.l044.attention_choice.v1',
      'micro.es.a0.ask_for_help':
          'template.es.a0.m07.l045.help_question_choice.v1',
      'micro.es.a0.state_need_for_help':
          'template.es.a0.m07.l045.fill_ayudarme.v1',
      'micro.es.a0.state_lack_of_understanding':
          'template.es.a0.m01.l003.type_no_entiendo.v1',
      'micro.es.a0.request_repetition':
          'template.es.a0.m07.l046.fill_repita.v1',
      'micro.es.a0.request_slower_speech':
          'template.es.a0.m07.l046.repair_choice.v1',
      'micro.es.a0.ask_where_service_is':
          'template.es.a0.m07.l047.service_choice.v1',
      'micro.es.a0.request_medical_help':
          'template.es.a0.m07.l048.emergency_choice.v1',
      'micro.es.a0.request_police_help':
          'template.es.a0.m07.l048.fill_medico.v1',
      'micro.es.a0.state_emergency':
          'template.es.a0.m07.l048.emergency_choice.v1',
      'micro.es.a0.respond_in_help_exchange':
          'template.es.a0.m04.l025.dialogue_comprehension.v1',
      'micro.es.a0.complete_basic_help_exchange':
          'template.es.a0.m07.l049.dialogue_comprehension.v1',
    },
  ),

  RuntimeCompetencyDefinition(
    competency: CommunicativeCompetencyDefinition(
      competencyId: 'competency.es.a0.m08.describe_basic_family_and_home',
      moduleId: 'es.a0.m08',
      title: 'Basic family and home check',
      communicativeGoal:
          'Identify close family members, describe a simple home, and complete a short family/home exchange.',
      requiredMicroCompetencyIds: [
        'micro.es.a0.identify_family_member',
        'micro.es.a0.state_family_member_name',
        'micro.es.a0.state_family_relationship',
        'micro.es.a0.ask_about_family',
        'micro.es.a0.state_basic_family_information',
        'micro.es.a0.state_have_family_member',
        'micro.es.a0.understand_short_family_profile',
        'micro.es.a0.identify_home_room',
        'micro.es.a0.name_household_object',
        'micro.es.a0.ask_where_person_or_object_is',
        'micro.es.a0.state_person_or_object_location',
        'micro.es.a0.describe_basic_home',
        'micro.es.a0.understand_short_home_description',
        'micro.es.a0.respond_in_family_home_exchange',
        'micro.es.a0.complete_basic_family_home_exchange',
      ],
      assessmentTaskIds: [
        'task.es.a0.m08.identify_family_member',
        'task.es.a0.m08.ask_about_family',
        'task.es.a0.m08.answer_family_question',
        'task.es.a0.m08.identify_room_object',
        'task.es.a0.m08.ask_and_state_location',
        'task.es.a0.m08.describe_basic_home',
        'task.es.a0.m08.family_home_exchange',
      ],
    ),
    diagnosticTaskTemplateIds: {
      'task.es.a0.m08.identify_family_member':
          'template.es.a0.m08.competency.identify_family_member.v1',
      'task.es.a0.m08.ask_about_family':
          'template.es.a0.m08.competency.ask_about_family.v1',
      'task.es.a0.m08.answer_family_question':
          'template.es.a0.m08.competency.answer_family_question.v1',
      'task.es.a0.m08.identify_room_object':
          'template.es.a0.m08.competency.identify_room_object.v1',
      'task.es.a0.m08.ask_and_state_location':
          'template.es.a0.m08.competency.ask_and_state_location.v1',
      'task.es.a0.m08.describe_basic_home':
          'template.es.a0.m08.competency.basic_home_description.v1',
      'task.es.a0.m08.family_home_exchange':
          'template.es.a0.m08.competency.family_home_exchange.v1',
    },
    recoveryTemplateIds: {
      'micro.es.a0.identify_family_member':
          'template.es.a0.m08.l052.family_member_choice.v1',
      'micro.es.a0.state_family_member_name':
          'template.es.a0.m08.l053.fill_se_llama.v1',
      'micro.es.a0.state_family_relationship':
          'template.es.a0.m08.l053.who_sister_choice.v1',
      'micro.es.a0.ask_about_family':
          'template.es.a0.m08.l054.type_tienes_hermanos.v1',
      'micro.es.a0.state_basic_family_information':
          'template.es.a0.m08.l054.type_tengo_una_hermana.v1',
      'micro.es.a0.state_have_family_member':
          'template.es.a0.m08.l054.tengo_form_choice.v1',
      'micro.es.a0.understand_short_family_profile':
          'template.es.a0.m08.l053.who_sister_choice.v1',
      'micro.es.a0.identify_home_room':
          'template.es.a0.m08.l055.room_choice.v1',
      'micro.es.a0.name_household_object':
          'template.es.a0.m08.l056.object_choice.v1',
      'micro.es.a0.ask_where_person_or_object_is':
          'template.es.a0.m06.l037.where_question_choice.v1',
      'micro.es.a0.state_person_or_object_location':
          'template.es.a0.m08.l056.type_la_mesa_esta_cocina.v1',
      'micro.es.a0.describe_basic_home':
          'template.es.a0.m08.l057.type_basic_home_profile.v1',
      'micro.es.a0.understand_short_home_description':
          'template.es.a0.m08.l057.profile_choice.v1',
      'micro.es.a0.respond_in_family_home_exchange':
          'template.es.a0.m04.l025.dialogue_comprehension.v1',
      'micro.es.a0.complete_basic_family_home_exchange':
          'template.es.a0.m08.l058.dialogue_comprehension.v1',
      'recovery.es.a0.m08.state_person_name.m04':
          'template.es.a0.m04.l020.fill_se_llama.v1',
      'recovery.es.a0.m08.state_location.m06':
          'template.es.a0.m06.l037.where_question_choice.v1',
    },
  ),
];

const _microCompetencies = [
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.introduce_self',
    description: 'Introduce oneself with the me llamo pattern.',
    introducedInModuleId: 'es.a0.m02',
    prerequisiteContentReferences: [
      'template.es.a0.m02.l004.type_me_llamo_carlos.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.state_origin',
    description: 'State origin with soy de.',
    introducedInModuleId: 'es.a0.m03',
    prerequisiteContentReferences: [
      'template.es.a0.m03.l013.type_soy_de_ucrania.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.ask_origin',
    description: 'Ask where one person is from.',
    introducedInModuleId: 'es.a0.m03',
    prerequisiteContentReferences: [
      'template.es.a0.m03.l014.type_de_donde_eres.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.state_residence',
    description: 'State residence with vivo en.',
    introducedInModuleId: 'es.a0.m03',
    prerequisiteContentReferences: [
      'template.es.a0.m03.l015.type_vivo_en_kyiv.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.ask_residence',
    description: 'Ask where one person lives.',
    introducedInModuleId: 'es.a0.m03',
    prerequisiteContentReferences: [
      'template.es.a0.m03.l015.type_donde_vives.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.state_languages',
    description: 'State spoken languages with hablo.',
    introducedInModuleId: 'es.a0.m03',
    prerequisiteContentReferences: [
      'template.es.a0.m03.l016.type_hablo_ucraniano_y_ruso.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.ask_languages',
    description: 'Ask which languages one person speaks.',
    introducedInModuleId: 'es.a0.m03',
    prerequisiteContentReferences: [
      'template.es.a0.m03.l016.type_que_idiomas_hablas.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.state_limited_language_ability',
    description: 'State limited language ability with un poco de.',
    introducedInModuleId: 'es.a0.m03',
    prerequisiteContentReferences: [
      'template.es.a0.m03.l016.type_hablo_un_poco_espanol.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.understand_personal_identity_profile',
    description: 'Understand a short personal identity profile.',
    introducedInModuleId: 'es.a0.m03',
    prerequisiteContentReferences: [
      'template.es.a0.m03.l018.reading_profile_choice.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.build_personal_identity_profile',
    description:
        'Build a short profile with name, origin, residence and languages.',
    introducedInModuleId: 'es.a0.m03',
    prerequisiteContentReferences: [
      'template.es.a0.m03.l018.type_profile_elena.v1',
    ],
  ),

  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.identify_person',
    description: 'Identify another person with ¿Quién es? and es.',
    introducedInModuleId: 'es.a0.m04',
    prerequisiteContentReferences: ['template.es.a0.m04.l020.type_quien_es.v1'],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.state_person_name',
    description: 'State another person’s name with se llama.',
    introducedInModuleId: 'es.a0.m04',
    prerequisiteContentReferences: [
      'template.es.a0.m04.l020.type_se_llama_marta.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.ask_who_person_is',
    description: 'Ask who another person is.',
    introducedInModuleId: 'es.a0.m04',
    prerequisiteContentReferences: ['template.es.a0.m04.l020.type_quien_es.v1'],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.state_person_role',
    description: 'State a simple role or relationship for another person.',
    introducedInModuleId: 'es.a0.m04',
    prerequisiteContentReferences: [
      'template.es.a0.m04.l021.type_es_mi_amiga.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.describe_person_basic',
    description: 'Describe another person with one controlled adjective.',
    introducedInModuleId: 'es.a0.m04',
    prerequisiteContentReferences: [
      'template.es.a0.m04.l022.type_es_simpatica.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.ask_about_person',
    description: 'Ask simple questions about another person.',
    introducedInModuleId: 'es.a0.m04',
    prerequisiteContentReferences: [
      'template.es.a0.m04.l025.type_ask_who_and_live.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.state_person_origin',
    description: 'State another person’s origin with es de.',
    introducedInModuleId: 'es.a0.m04',
    prerequisiteContentReferences: [
      'template.es.a0.m04.l023.type_es_de_espana.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.state_person_residence',
    description: 'State another person’s residence with vive en.',
    introducedInModuleId: 'es.a0.m04',
    prerequisiteContentReferences: [
      'template.es.a0.m04.l023.type_vive_en_lima.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.state_person_languages',
    description: 'State another person’s languages with habla.',
    introducedInModuleId: 'es.a0.m04',
    prerequisiteContentReferences: [
      'template.es.a0.m04.l023.type_habla_ingles.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.understand_person_description',
    description: 'Understand a short description of another person.',
    introducedInModuleId: 'es.a0.m04',
    prerequisiteContentReferences: [
      'template.es.a0.m04.l025.dialogue_comprehension.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.respond_in_everyday_exchange',
    description: 'Respond in a short everyday exchange about another person.',
    introducedInModuleId: 'es.a0.m04',
    prerequisiteContentReferences: [
      'template.es.a0.m04.l025.type_everyday_answer.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.sustain_short_everyday_conversation',
    description: 'Sustain a bounded short conversation about another person.',
    introducedInModuleId: 'es.a0.m04',
    prerequisiteContentReferences: [
      'template.es.a0.m04.competency.everyday_exchange.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.exchange_personal_identity_information',
    description: 'Exchange basic identity questions and answers.',
    introducedInModuleId: 'es.a0.m03',
    prerequisiteContentReferences: [
      'template.es.a0.m03.l017.type_ask_origin_and_languages.v1',
    ],
  ),

  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.identify_everyday_object',
    description: 'Identify a familiar everyday object by name.',
    introducedInModuleId: 'es.a0.m05',
    prerequisiteContentReferences: [
      'template.es.a0.m05.l028.type_es_una_botella.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.ask_what_object_is',
    description: 'Ask what an unknown object is.',
    introducedInModuleId: 'es.a0.m05',
    prerequisiteContentReferences: [
      'template.es.a0.m05.l028.type_que_es_esto.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.name_everyday_object',
    description: 'Name a familiar object with un or una.',
    introducedInModuleId: 'es.a0.m05',
    prerequisiteContentReferences: [
      'template.es.a0.m05.l028.type_es_una_botella.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.ask_item_availability',
    description: 'Ask politely whether a shop has a familiar item.',
    introducedInModuleId: 'es.a0.m05',
    prerequisiteContentReferences: [
      'template.es.a0.m05.l029.type_tiene_agua.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.state_item_availability',
    description: 'Answer availability with tenemos or no tenemos.',
    introducedInModuleId: 'es.a0.m05',
    prerequisiteContentReferences: [
      'template.es.a0.m05.l029.type_si_tenemos_agua.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.ask_price',
    description: 'Ask a simple price with ¿Cuánto cuesta?',
    introducedInModuleId: 'es.a0.m05',
    prerequisiteContentReferences: [
      'template.es.a0.m05.l030.type_cuanto_cuesta.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.understand_price',
    description: 'Understand a controlled price in euros.',
    introducedInModuleId: 'es.a0.m05',
    prerequisiteContentReferences: [
      'template.es.a0.m05.l030.price_comprehension_choice.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.state_price',
    description: 'State a controlled price in euros.',
    introducedInModuleId: 'es.a0.m05',
    prerequisiteContentReferences: [
      'template.es.a0.m05.l030.type_cuesta_cinco_euros.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.express_expensive_or_cheap',
    description: 'Say whether a familiar item is cheap or expensive.',
    introducedInModuleId: 'es.a0.m05',
    prerequisiteContentReferences: [
      'template.es.a0.m05.l031.type_el_libro_es_caro.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.express_purchase_intention',
    description: 'Express a basic purchase intention with quiero.',
    introducedInModuleId: 'es.a0.m05',
    prerequisiteContentReferences: [
      'template.es.a0.m05.l032.type_quiero_una_botella.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.request_one_item',
    description: 'Request one familiar item politely.',
    introducedInModuleId: 'es.a0.m05',
    prerequisiteContentReferences: [
      'template.es.a0.m05.l032.type_este_libro.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.request_small_quantity',
    description: 'Request a small controlled quantity of a familiar item.',
    introducedInModuleId: 'es.a0.m05',
    prerequisiteContentReferences: [
      'template.es.a0.m05.l032.type_quiero_una_botella.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.respond_to_seller',
    description: 'Respond to a seller with a polite closing.',
    introducedInModuleId: 'es.a0.m05',
    prerequisiteContentReferences: ['template.es.a0.m05.l032.type_nada_mas.v1'],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.complete_basic_purchase_exchange',
    description: 'Complete a short predictable shopping exchange.',
    introducedInModuleId: 'es.a0.m05',
    prerequisiteContentReferences: [
      'template.es.a0.m05.l033.type_basic_purchase_exchange.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.understand_short_shopping_dialogue',
    description: 'Understand a short shopping dialogue.',
    introducedInModuleId: 'es.a0.m05',
    prerequisiteContentReferences: [
      'template.es.a0.m05.l033.dialogue_order_choice.v1',
    ],
  ),

  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.identify_transport',
    description: 'Recognize common transport words.',
    introducedInModuleId: 'es.a0.m06',
    prerequisiteContentReferences: [
      'template.es.a0.m06.l036.transport_choice.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.name_transport',
    description: 'Name a common transport method in a short phrase.',
    introducedInModuleId: 'es.a0.m06',
    prerequisiteContentReferences: [
      'template.es.a0.m06.l036.type_voy_en_metro.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.ask_where_place_is',
    description: 'Ask where a familiar place is.',
    introducedInModuleId: 'es.a0.m06',
    prerequisiteContentReferences: [
      'template.es.a0.m06.l037.type_donde_esta_estacion.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.state_place_location',
    description: 'State a familiar place location with está.',
    introducedInModuleId: 'es.a0.m06',
    prerequisiteContentReferences: [
      'template.es.a0.m06.l037.type_esta_cerca.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.ask_how_to_get_somewhere',
    description: 'Ask how to get to a familiar place.',
    introducedInModuleId: 'es.a0.m06',
    prerequisiteContentReferences: [
      'template.es.a0.m06.l040.type_como_llego_hotel.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.understand_simple_directions',
    description: 'Understand simple directions such as straight, left, right.',
    introducedInModuleId: 'es.a0.m06',
    prerequisiteContentReferences: [
      'template.es.a0.m06.l038.left_right_choice.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.give_simple_directions',
    description: 'Give one or two simple directions in order.',
    introducedInModuleId: 'es.a0.m06',
    prerequisiteContentReferences: [
      'template.es.a0.m06.l038.type_sigue_recto.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.distinguish_left_right',
    description: 'Distinguish izquierda and derecha.',
    introducedInModuleId: 'es.a0.m06',
    prerequisiteContentReferences: [
      'template.es.a0.m06.l038.type_gira_izquierda.v1',
      'template.es.a0.m06.l038.type_gira_derecha.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.understand_near_far',
    description: 'Understand and use cerca and lejos.',
    introducedInModuleId: 'es.a0.m06',
    prerequisiteContentReferences: [
      'template.es.a0.m06.l039.type_esta_lejos.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.ask_which_transport',
    description: 'Ask which transport to take.',
    introducedInModuleId: 'es.a0.m06',
    prerequisiteContentReferences: [
      'template.es.a0.m06.l041.type_que_transporte_tomo.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.state_transport_method',
    description: 'State a simple transport method.',
    introducedInModuleId: 'es.a0.m06',
    prerequisiteContentReferences: [
      'template.es.a0.m06.l041.type_toma_metro.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.understand_short_route_instruction',
    description: 'Understand a short route instruction in order.',
    introducedInModuleId: 'es.a0.m06',
    prerequisiteContentReferences: [
      'template.es.a0.m06.review.route_note_choice.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.respond_in_direction_exchange',
    description: 'Respond appropriately in a short directions exchange.',
    introducedInModuleId: 'es.a0.m06',
    prerequisiteContentReferences: [
      'template.es.a0.m06.l041.transport_answer_choice.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.complete_basic_route_exchange',
    description: 'Complete a short predictable route exchange.',
    introducedInModuleId: 'es.a0.m06',
    prerequisiteContentReferences: [
      'template.es.a0.m06.competency.route_exchange.v1',
    ],
  ),

  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.get_attention_politely',
    description: 'Attract attention politely with disculpe.',
    introducedInModuleId: 'es.a0.m07',
    prerequisiteContentReferences: ['template.es.a0.m07.l044.type_disculpe.v1'],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.ask_for_help',
    description: 'Ask for help with ¿Puede ayudarme?',
    introducedInModuleId: 'es.a0.m07',
    prerequisiteContentReferences: [
      'template.es.a0.m07.l045.type_puede_ayudarme.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.state_need_for_help',
    description: 'State a need for help with necesito ayuda.',
    introducedInModuleId: 'es.a0.m07',
    prerequisiteContentReferences: [
      'template.es.a0.m07.l045.type_necesito_ayuda.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.state_lack_of_understanding',
    description: 'Say that the learner does not understand.',
    introducedInModuleId: 'es.a0.m01',
    prerequisiteContentReferences: [
      'template.es.a0.m01.l003.type_no_entiendo.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.request_repetition',
    description: 'Ask someone to repeat politely.',
    introducedInModuleId: 'es.a0.m07',
    prerequisiteContentReferences: [
      'template.es.a0.m07.l046.type_repita_por_favor.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.request_slower_speech',
    description: 'Ask someone to speak more slowly.',
    introducedInModuleId: 'es.a0.m07',
    prerequisiteContentReferences: [
      'template.es.a0.m07.l046.type_hable_mas_despacio.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.ask_where_service_is',
    description: 'Ask where an important service is.',
    introducedInModuleId: 'es.a0.m07',
    prerequisiteContentReferences: [
      'template.es.a0.m07.l047.type_donde_bano.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.request_medical_help',
    description: 'Request a doctor in a simple urgent situation.',
    introducedInModuleId: 'es.a0.m07',
    prerequisiteContentReferences: [
      'template.es.a0.m07.l048.type_necesito_medico.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.request_police_help',
    description: 'Request the police in a simple urgent situation.',
    introducedInModuleId: 'es.a0.m07',
    prerequisiteContentReferences: [
      'template.es.a0.m07.l048.type_necesito_policia.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.state_emergency',
    description: 'State that a situation is an emergency.',
    introducedInModuleId: 'es.a0.m07',
    prerequisiteContentReferences: [
      'template.es.a0.m07.l048.type_es_emergencia.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.respond_in_help_exchange',
    description: 'Respond appropriately in a short help exchange.',
    introducedInModuleId: 'es.a0.m07',
    prerequisiteContentReferences: [
      'template.es.a0.m07.l049.dialogue_comprehension.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.complete_basic_help_exchange',
    description: 'Complete a short predictable help exchange.',
    introducedInModuleId: 'es.a0.m07',
    prerequisiteContentReferences: [
      'template.es.a0.m07.competency.complete_help_exchange.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.identify_family_member',
    description: 'Identify a close family member in a controlled prompt.',
    introducedInModuleId: 'es.a0.m08',
    prerequisiteContentReferences: [
      'template.es.a0.m08.l052.family_member_choice.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.state_family_member_name',
    description: 'State a family member name with se llama.',
    introducedInModuleId: 'es.a0.m08',
    prerequisiteContentReferences: ['template.es.a0.m08.l053.fill_se_llama.v1'],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.state_family_relationship',
    description: 'State a basic family relationship.',
    introducedInModuleId: 'es.a0.m08',
    prerequisiteContentReferences: [
      'template.es.a0.m08.l053.who_sister_choice.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.ask_about_family',
    description: 'Ask a controlled question about siblings.',
    introducedInModuleId: 'es.a0.m08',
    prerequisiteContentReferences: [
      'template.es.a0.m08.l054.type_tienes_hermanos.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.state_basic_family_information',
    description: 'State one bounded fact about a family member.',
    introducedInModuleId: 'es.a0.m08',
    prerequisiteContentReferences: [
      'template.es.a0.m08.l054.type_tengo_una_hermana.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.state_have_family_member',
    description: 'Use tengo/tienes/tiene for controlled family facts.',
    introducedInModuleId: 'es.a0.m08',
    prerequisiteContentReferences: [
      'template.es.a0.m08.l054.tengo_form_choice.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.understand_short_family_profile',
    description: 'Understand a short authored family profile.',
    introducedInModuleId: 'es.a0.m08',
    prerequisiteContentReferences: ['reading.es.a0.m08.family_profile.v1'],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.identify_home_room',
    description: 'Identify a common room in a home.',
    introducedInModuleId: 'es.a0.m08',
    prerequisiteContentReferences: ['template.es.a0.m08.l055.room_choice.v1'],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.name_household_object',
    description: 'Name a common household object.',
    introducedInModuleId: 'es.a0.m08',
    prerequisiteContentReferences: ['template.es.a0.m08.l056.object_choice.v1'],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.ask_where_person_or_object_is',
    description: 'Ask where a person or object is.',
    introducedInModuleId: 'es.a0.m08',
    prerequisiteContentReferences: [
      'template.es.a0.m08.l056.type_donde_esta_mesa.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.state_person_or_object_location',
    description: 'State the simple location of a person or object.',
    introducedInModuleId: 'es.a0.m08',
    prerequisiteContentReferences: [
      'template.es.a0.m08.l056.type_la_mesa_esta_cocina.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.describe_basic_home',
    description: 'Describe a simple home with bounded known patterns.',
    introducedInModuleId: 'es.a0.m08',
    prerequisiteContentReferences: [
      'template.es.a0.m08.l057.type_basic_home_profile.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.understand_short_home_description',
    description: 'Understand a short authored home description.',
    introducedInModuleId: 'es.a0.m08',
    prerequisiteContentReferences: ['reading.es.a0.m08.objects_location.v1'],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.respond_in_family_home_exchange',
    description: 'Respond in a short family and home exchange.',
    introducedInModuleId: 'es.a0.m08',
    prerequisiteContentReferences: [
      'template.es.a0.m08.l058.dialogue_comprehension.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.complete_basic_family_home_exchange',
    description: 'Complete a bounded family and home exchange.',
    introducedInModuleId: 'es.a0.m08',
    prerequisiteContentReferences: [
      'template.es.a0.m08.competency.family_home_exchange.v1',
    ],
  ),
];

const _assessmentTasks = [
  CompetencyAssessmentTask(
    taskId: 'task.es.a0.introduce_self',
    competencyId: 'competency.es.a0.m03.describe_basic_personal_identity',
    assessedMicroCompetencyIds: ['micro.es.a0.introduce_self'],
    lessonStepReference: 'template.es.a0.m03.competency.type_intro_marta.v1',
    recoveryMappings: [
      CompetencyRecoveryMapping(
        microCompetencyId: 'micro.es.a0.introduce_self',
        reasonCode: CompetencyGapReasonCode.prerequisiteNotRetained,
        recoveryStepReferences: [
          CompetencyRecoveryStepReference(
            stepId: 'template.es.a0.m02.l004.name_pattern_choice.v1',
            sourceModuleId: 'es.a0.m02',
            sourceLessonId: 'es.a0.m02.l004',
            sourceStepId: 'template.es.a0.m02.l004.name_pattern_choice.v1',
          ),
        ],
        retryTaskId: 'task.es.a0.introduce_self',
      ),
    ],
  ),
  CompetencyAssessmentTask(
    taskId: 'task.es.a0.state_origin',
    competencyId: 'competency.es.a0.m03.describe_basic_personal_identity',
    assessedMicroCompetencyIds: ['micro.es.a0.state_origin'],
    lessonStepReference: 'template.es.a0.m03.competency.type_origin_ucrania.v1',
    recoveryMappings: [
      CompetencyRecoveryMapping(
        microCompetencyId: 'micro.es.a0.state_origin',
        reasonCode: CompetencyGapReasonCode.missingStructure,
        recoveryStepReferences: [
          CompetencyRecoveryStepReference(
            stepId: 'template.es.a0.m03.l013.origin_choice.v1',
            sourceModuleId: 'es.a0.m03',
            sourceLessonId: 'es.a0.m03.l013',
            sourceStepId: 'template.es.a0.m03.l013.origin_choice.v1',
          ),
        ],
        retryTaskId: 'task.es.a0.state_origin',
      ),
    ],
  ),
  CompetencyAssessmentTask(
    taskId: 'task.es.a0.state_residence',
    competencyId: 'competency.es.a0.m03.describe_basic_personal_identity',
    assessedMicroCompetencyIds: ['micro.es.a0.state_residence'],
    lessonStepReference: 'template.es.a0.m03.competency.type_residence_kyiv.v1',
    recoveryMappings: [
      CompetencyRecoveryMapping(
        microCompetencyId: 'micro.es.a0.state_residence',
        reasonCode: CompetencyGapReasonCode.missingStructure,
        recoveryStepReferences: [
          CompetencyRecoveryStepReference(
            stepId: 'template.es.a0.m03.l015.residence_choice.v1',
            sourceModuleId: 'es.a0.m03',
            sourceLessonId: 'es.a0.m03.l015',
            sourceStepId: 'template.es.a0.m03.l015.residence_choice.v1',
          ),
        ],
        retryTaskId: 'task.es.a0.state_residence',
      ),
    ],
  ),
  CompetencyAssessmentTask(
    taskId: 'task.es.a0.state_languages',
    competencyId: 'competency.es.a0.m03.describe_basic_personal_identity',
    assessedMicroCompetencyIds: [
      'micro.es.a0.state_languages',
      'micro.es.a0.state_limited_language_ability',
    ],
    lessonStepReference:
        'template.es.a0.m03.competency.type_languages_ucranian_spanish.v1',
    recoveryMappings: [
      CompetencyRecoveryMapping(
        microCompetencyId: 'micro.es.a0.state_languages',
        reasonCode: CompetencyGapReasonCode.missingVocabulary,
        recoveryStepReferences: [
          CompetencyRecoveryStepReference(
            stepId: 'template.es.a0.m03.l016.language_choice.v1',
            sourceModuleId: 'es.a0.m03',
            sourceLessonId: 'es.a0.m03.l016',
            sourceStepId: 'template.es.a0.m03.l016.language_choice.v1',
          ),
        ],
        retryTaskId: 'task.es.a0.state_languages',
      ),
    ],
  ),
  CompetencyAssessmentTask(
    taskId: 'task.es.a0.ask_origin_and_languages',
    competencyId: 'competency.es.a0.m03.describe_basic_personal_identity',
    assessedMicroCompetencyIds: [
      'micro.es.a0.ask_origin',
      'micro.es.a0.ask_languages',
    ],
    lessonStepReference:
        'template.es.a0.m03.competency.type_ask_origin_languages.v1',
    recoveryMappings: [
      CompetencyRecoveryMapping(
        microCompetencyId: 'micro.es.a0.ask_origin',
        reasonCode: CompetencyGapReasonCode.incorrectQuestionForm,
        recoveryStepReferences: [
          CompetencyRecoveryStepReference(
            stepId: 'template.es.a0.m03.l014.origin_question_choice.v1',
            sourceModuleId: 'es.a0.m03',
            sourceLessonId: 'es.a0.m03.l014',
            sourceStepId: 'template.es.a0.m03.l014.origin_question_choice.v1',
          ),
        ],
        retryTaskId: 'task.es.a0.ask_origin_and_languages',
      ),
      CompetencyRecoveryMapping(
        microCompetencyId: 'micro.es.a0.ask_languages',
        reasonCode: CompetencyGapReasonCode.incorrectQuestionForm,
        recoveryStepReferences: [
          CompetencyRecoveryStepReference(
            stepId: 'template.es.a0.m03.l017.exchange_question_choice.v1',
            sourceModuleId: 'es.a0.m03',
            sourceLessonId: 'es.a0.m03.l017',
            sourceStepId: 'template.es.a0.m03.l017.exchange_question_choice.v1',
          ),
        ],
        retryTaskId: 'task.es.a0.ask_origin_and_languages',
      ),
    ],
  ),

  CompetencyAssessmentTask(
    taskId: 'task.es.a0.m04.identify_person',
    competencyId:
        'competency.es.a0.m04.describe_person_and_hold_basic_conversation',
    assessedMicroCompetencyIds: [
      'micro.es.a0.identify_person',
      'micro.es.a0.state_person_name',
    ],
    lessonStepReference: 'template.es.a0.m04.competency.identify_person.v1',
    recoveryMappings: [
      CompetencyRecoveryMapping(
        microCompetencyId: 'micro.es.a0.state_person_name',
        reasonCode: CompetencyGapReasonCode.missingStructure,
        recoveryStepReferences: [
          CompetencyRecoveryStepReference(
            stepId: 'template.es.a0.m04.l020.fill_se_llama.v1',
            sourceModuleId: 'es.a0.m04',
            sourceLessonId: 'es.a0.m04.l020',
            sourceStepId: 'template.es.a0.m04.l020.fill_se_llama.v1',
          ),
        ],
        retryTaskId: 'task.es.a0.m04.identify_person',
      ),
    ],
  ),
  CompetencyAssessmentTask(
    taskId: 'task.es.a0.m04.state_person_role',
    competencyId:
        'competency.es.a0.m04.describe_person_and_hold_basic_conversation',
    assessedMicroCompetencyIds: ['micro.es.a0.state_person_role'],
    lessonStepReference: 'template.es.a0.m04.competency.state_role.v1',
    recoveryMappings: [
      CompetencyRecoveryMapping(
        microCompetencyId: 'micro.es.a0.state_person_role',
        reasonCode: CompetencyGapReasonCode.missingVocabulary,
        recoveryStepReferences: [
          CompetencyRecoveryStepReference(
            stepId: 'template.es.a0.m04.l021.role_choice.v1',
            sourceModuleId: 'es.a0.m04',
            sourceLessonId: 'es.a0.m04.l021',
            sourceStepId: 'template.es.a0.m04.l021.role_choice.v1',
          ),
        ],
        retryTaskId: 'task.es.a0.m04.state_person_role',
      ),
    ],
  ),
  CompetencyAssessmentTask(
    taskId: 'task.es.a0.m04.describe_person_basic',
    competencyId:
        'competency.es.a0.m04.describe_person_and_hold_basic_conversation',
    assessedMicroCompetencyIds: ['micro.es.a0.describe_person_basic'],
    lessonStepReference: 'template.es.a0.m04.competency.describe_person.v1',
    recoveryMappings: [
      CompetencyRecoveryMapping(
        microCompetencyId: 'micro.es.a0.describe_person_basic',
        reasonCode: CompetencyGapReasonCode.missingVocabulary,
        recoveryStepReferences: [
          CompetencyRecoveryStepReference(
            stepId: 'template.es.a0.m04.l022.description_question_choice.v1',
            sourceModuleId: 'es.a0.m04',
            sourceLessonId: 'es.a0.m04.l022',
            sourceStepId:
                'template.es.a0.m04.l022.description_question_choice.v1',
          ),
        ],
        retryTaskId: 'task.es.a0.m04.describe_person_basic',
      ),
    ],
  ),
  CompetencyAssessmentTask(
    taskId: 'task.es.a0.m04.state_person_facts',
    competencyId:
        'competency.es.a0.m04.describe_person_and_hold_basic_conversation',
    assessedMicroCompetencyIds: [
      'micro.es.a0.state_person_origin',
      'micro.es.a0.state_person_residence',
      'micro.es.a0.state_person_languages',
    ],
    lessonStepReference: 'template.es.a0.m04.competency.person_facts.v1',
    recoveryMappings: [
      CompetencyRecoveryMapping(
        microCompetencyId: 'micro.es.a0.state_person_origin',
        reasonCode: CompetencyGapReasonCode.prerequisiteNotRetained,
        recoveryStepReferences: [
          CompetencyRecoveryStepReference(
            stepId: 'template.es.a0.m03.l013.origin_choice.v1',
            sourceModuleId: 'es.a0.m03',
            sourceLessonId: 'es.a0.m03.l013',
            sourceStepId: 'template.es.a0.m03.l013.origin_choice.v1',
          ),
        ],
        retryTaskId: 'task.es.a0.m04.state_person_facts',
      ),
      CompetencyRecoveryMapping(
        microCompetencyId: 'micro.es.a0.state_person_residence',
        reasonCode: CompetencyGapReasonCode.prerequisiteNotRetained,
        recoveryStepReferences: [
          CompetencyRecoveryStepReference(
            stepId: 'template.es.a0.m03.l015.residence_choice.v1',
            sourceModuleId: 'es.a0.m03',
            sourceLessonId: 'es.a0.m03.l015',
            sourceStepId: 'template.es.a0.m03.l015.residence_choice.v1',
          ),
        ],
        retryTaskId: 'task.es.a0.m04.state_person_facts',
      ),
    ],
  ),
  CompetencyAssessmentTask(
    taskId: 'task.es.a0.m04.ask_about_person',
    competencyId:
        'competency.es.a0.m04.describe_person_and_hold_basic_conversation',
    assessedMicroCompetencyIds: [
      'micro.es.a0.ask_who_person_is',
      'micro.es.a0.ask_about_person',
    ],
    lessonStepReference: 'template.es.a0.m04.competency.ask_about_person.v1',
    recoveryMappings: [
      CompetencyRecoveryMapping(
        microCompetencyId: 'micro.es.a0.ask_about_person',
        reasonCode: CompetencyGapReasonCode.incorrectQuestionForm,
        recoveryStepReferences: [
          CompetencyRecoveryStepReference(
            stepId: 'template.es.a0.m04.l024.yes_no_choice.v1',
            sourceModuleId: 'es.a0.m04',
            sourceLessonId: 'es.a0.m04.l024',
            sourceStepId: 'template.es.a0.m04.l024.yes_no_choice.v1',
          ),
        ],
        retryTaskId: 'task.es.a0.m04.ask_about_person',
      ),
    ],
  ),
  CompetencyAssessmentTask(
    taskId: 'task.es.a0.m04.everyday_exchange',
    competencyId:
        'competency.es.a0.m04.describe_person_and_hold_basic_conversation',
    assessedMicroCompetencyIds: [
      'micro.es.a0.respond_in_everyday_exchange',
      'micro.es.a0.sustain_short_everyday_conversation',
    ],
    lessonStepReference: 'template.es.a0.m04.competency.everyday_exchange.v1',
    isCentralTask: true,
    recoveryMappings: [
      CompetencyRecoveryMapping(
        microCompetencyId: 'micro.es.a0.sustain_short_everyday_conversation',
        reasonCode: CompetencyGapReasonCode.integrationFailure,
        recoveryStepReferences: [
          CompetencyRecoveryStepReference(
            stepId: 'template.es.a0.m04.l025.dialogue_comprehension.v1',
            sourceModuleId: 'es.a0.m04',
            sourceLessonId: 'es.a0.m04.l025',
            sourceStepId: 'template.es.a0.m04.l025.dialogue_comprehension.v1',
          ),
        ],
        retryTaskId: 'task.es.a0.m04.everyday_exchange',
      ),
    ],
  ),

  CompetencyAssessmentTask(
    taskId: 'task.es.a0.m05.identify_object',
    competencyId: 'competency.es.a0.m05.complete_basic_shopping_exchange',
    assessedMicroCompetencyIds: [
      'micro.es.a0.ask_what_object_is',
      'micro.es.a0.identify_everyday_object',
      'micro.es.a0.name_everyday_object',
    ],
    lessonStepReference: 'template.es.a0.m05.competency.identify_object.v1',
    recoveryMappings: [
      CompetencyRecoveryMapping(
        microCompetencyId: 'micro.es.a0.identify_everyday_object',
        reasonCode: CompetencyGapReasonCode.missingVocabulary,
        recoveryStepReferences: [
          CompetencyRecoveryStepReference(
            stepId: 'template.es.a0.m05.l028.object_choice.v1',
            sourceModuleId: 'es.a0.m05',
            sourceLessonId: 'es.a0.m05.l028',
            sourceStepId: 'template.es.a0.m05.l028.object_choice.v1',
          ),
        ],
        retryTaskId: 'task.es.a0.m05.identify_object',
      ),
    ],
  ),
  CompetencyAssessmentTask(
    taskId: 'task.es.a0.m05.ask_availability',
    competencyId: 'competency.es.a0.m05.complete_basic_shopping_exchange',
    assessedMicroCompetencyIds: ['micro.es.a0.ask_item_availability'],
    lessonStepReference: 'template.es.a0.m05.competency.ask_availability.v1',
    recoveryMappings: [
      CompetencyRecoveryMapping(
        microCompetencyId: 'micro.es.a0.ask_item_availability',
        reasonCode: CompetencyGapReasonCode.incorrectQuestionForm,
        recoveryStepReferences: [
          CompetencyRecoveryStepReference(
            stepId: 'template.es.a0.m05.l029.availability_question_choice.v1',
            sourceModuleId: 'es.a0.m05',
            sourceLessonId: 'es.a0.m05.l029',
            sourceStepId:
                'template.es.a0.m05.l029.availability_question_choice.v1',
          ),
        ],
        retryTaskId: 'task.es.a0.m05.ask_availability',
      ),
    ],
  ),
  CompetencyAssessmentTask(
    taskId: 'task.es.a0.m05.ask_price',
    competencyId: 'competency.es.a0.m05.complete_basic_shopping_exchange',
    assessedMicroCompetencyIds: ['micro.es.a0.ask_price'],
    lessonStepReference: 'template.es.a0.m05.competency.ask_price.v1',
    recoveryMappings: [
      CompetencyRecoveryMapping(
        microCompetencyId: 'micro.es.a0.ask_price',
        reasonCode: CompetencyGapReasonCode.incorrectQuestionForm,
        recoveryStepReferences: [
          CompetencyRecoveryStepReference(
            stepId: 'template.es.a0.m05.l030.price_question_choice.v1',
            sourceModuleId: 'es.a0.m05',
            sourceLessonId: 'es.a0.m05.l030',
            sourceStepId: 'template.es.a0.m05.l030.price_question_choice.v1',
          ),
        ],
        retryTaskId: 'task.es.a0.m05.ask_price',
      ),
    ],
  ),
  CompetencyAssessmentTask(
    taskId: 'task.es.a0.m05.understand_price',
    competencyId: 'competency.es.a0.m05.complete_basic_shopping_exchange',
    assessedMicroCompetencyIds: ['micro.es.a0.understand_price'],
    lessonStepReference: 'template.es.a0.m05.competency.understand_price.v1',
    recoveryMappings: [
      CompetencyRecoveryMapping(
        microCompetencyId: 'micro.es.a0.understand_price',
        reasonCode: CompetencyGapReasonCode.missingVocabulary,
        recoveryStepReferences: [
          CompetencyRecoveryStepReference(
            stepId: 'template.es.a0.m05.l030.price_comprehension_choice.v1',
            sourceModuleId: 'es.a0.m05',
            sourceLessonId: 'es.a0.m05.l030',
            sourceStepId:
                'template.es.a0.m05.l030.price_comprehension_choice.v1',
          ),
        ],
        retryTaskId: 'task.es.a0.m05.understand_price',
      ),
    ],
  ),
  CompetencyAssessmentTask(
    taskId: 'task.es.a0.m05.request_item',
    competencyId: 'competency.es.a0.m05.complete_basic_shopping_exchange',
    assessedMicroCompetencyIds: [
      'micro.es.a0.express_purchase_intention',
      'micro.es.a0.request_one_item',
    ],
    lessonStepReference: 'template.es.a0.m05.competency.request_item.v1',
    recoveryMappings: [
      CompetencyRecoveryMapping(
        microCompetencyId: 'micro.es.a0.express_purchase_intention',
        reasonCode: CompetencyGapReasonCode.missingStructure,
        recoveryStepReferences: [
          CompetencyRecoveryStepReference(
            stepId: 'template.es.a0.m05.l032.request_choice.v1',
            sourceModuleId: 'es.a0.m05',
            sourceLessonId: 'es.a0.m05.l032',
            sourceStepId: 'template.es.a0.m05.l032.request_choice.v1',
          ),
        ],
        retryTaskId: 'task.es.a0.m05.request_item',
      ),
    ],
  ),
  CompetencyAssessmentTask(
    taskId: 'task.es.a0.m05.respond_seller',
    competencyId: 'competency.es.a0.m05.complete_basic_shopping_exchange',
    assessedMicroCompetencyIds: ['micro.es.a0.respond_to_seller'],
    lessonStepReference: 'template.es.a0.m05.competency.respond_seller.v1',
    recoveryMappings: [
      CompetencyRecoveryMapping(
        microCompetencyId: 'micro.es.a0.respond_to_seller',
        reasonCode: CompetencyGapReasonCode.prerequisiteNotRetained,
        recoveryStepReferences: [
          CompetencyRecoveryStepReference(
            stepId: 'template.es.a0.m01.l002.type_gracias.v1',
            sourceModuleId: 'es.a0.m01',
            sourceLessonId: 'es.a0.m01.l002',
            sourceStepId: 'template.es.a0.m01.l002.type_gracias.v1',
          ),
        ],
        retryTaskId: 'task.es.a0.m05.respond_seller',
      ),
    ],
  ),
  CompetencyAssessmentTask(
    taskId: 'task.es.a0.m05.basic_purchase_exchange',
    competencyId: 'competency.es.a0.m05.complete_basic_shopping_exchange',
    assessedMicroCompetencyIds: [
      'micro.es.a0.ask_item_availability',
      'micro.es.a0.ask_price',
      'micro.es.a0.express_purchase_intention',
      'micro.es.a0.respond_to_seller',
      'micro.es.a0.complete_basic_purchase_exchange',
    ],
    lessonStepReference:
        'template.es.a0.m05.competency.basic_purchase_exchange.v1',
    isCentralTask: true,
    recoveryMappings: [
      CompetencyRecoveryMapping(
        microCompetencyId: 'micro.es.a0.complete_basic_purchase_exchange',
        reasonCode: CompetencyGapReasonCode.integrationFailure,
        recoveryStepReferences: [
          CompetencyRecoveryStepReference(
            stepId: 'template.es.a0.m05.l033.dialogue_order_choice.v1',
            sourceModuleId: 'es.a0.m05',
            sourceLessonId: 'es.a0.m05.l033',
            sourceStepId: 'template.es.a0.m05.l033.dialogue_order_choice.v1',
          ),
        ],
        retryTaskId: 'task.es.a0.m05.basic_purchase_exchange',
      ),
      CompetencyRecoveryMapping(
        microCompetencyId: 'micro.es.a0.respond_to_seller',
        reasonCode: CompetencyGapReasonCode.prerequisiteNotRetained,
        recoveryStepReferences: [
          CompetencyRecoveryStepReference(
            stepId: 'template.es.a0.m04.l025.dialogue_comprehension.v1',
            sourceModuleId: 'es.a0.m04',
            sourceLessonId: 'es.a0.m04.l025',
            sourceStepId: 'template.es.a0.m04.l025.dialogue_comprehension.v1',
          ),
        ],
        retryTaskId: 'task.es.a0.m05.basic_purchase_exchange',
      ),
    ],
  ),
  CompetencyAssessmentTask(
    taskId: 'task.es.a0.m06.state_transport_method',
    competencyId: 'competency.es.a0.m06.ask_and_follow_basic_directions',
    assessedMicroCompetencyIds: [
      'micro.es.a0.identify_transport',
      'micro.es.a0.name_transport',
      'micro.es.a0.state_transport_method',
    ],
    lessonStepReference:
        'template.es.a0.m06.competency.state_transport_method.v1',
    recoveryMappings: [
      CompetencyRecoveryMapping(
        microCompetencyId: 'micro.es.a0.state_transport_method',
        reasonCode: CompetencyGapReasonCode.missingStructure,
        recoveryStepReferences: [
          CompetencyRecoveryStepReference(
            stepId: 'template.es.a0.m06.l041.fill_toma_metro.v1',
            sourceModuleId: 'es.a0.m06',
            sourceLessonId: 'es.a0.m06.l041',
            sourceStepId: 'template.es.a0.m06.l041.fill_toma_metro.v1',
          ),
        ],
        retryTaskId: 'task.es.a0.m06.state_transport_method',
      ),
    ],
  ),
  CompetencyAssessmentTask(
    taskId: 'task.es.a0.m06.ask_where_place_is',
    competencyId: 'competency.es.a0.m06.ask_and_follow_basic_directions',
    assessedMicroCompetencyIds: [
      'micro.es.a0.ask_where_place_is',
      'micro.es.a0.state_place_location',
    ],
    lessonStepReference: 'template.es.a0.m06.competency.ask_where_station.v1',
    recoveryMappings: [
      CompetencyRecoveryMapping(
        microCompetencyId: 'micro.es.a0.ask_where_place_is',
        reasonCode: CompetencyGapReasonCode.incorrectQuestionForm,
        recoveryStepReferences: [
          CompetencyRecoveryStepReference(
            stepId: 'template.es.a0.m06.l037.where_question_choice.v1',
            sourceModuleId: 'es.a0.m06',
            sourceLessonId: 'es.a0.m06.l037',
            sourceStepId: 'template.es.a0.m06.l037.where_question_choice.v1',
          ),
        ],
        retryTaskId: 'task.es.a0.m06.ask_where_place_is',
      ),
    ],
  ),
  CompetencyAssessmentTask(
    taskId: 'task.es.a0.m06.understand_simple_direction',
    competencyId: 'competency.es.a0.m06.ask_and_follow_basic_directions',
    assessedMicroCompetencyIds: [
      'micro.es.a0.understand_simple_directions',
      'micro.es.a0.distinguish_left_right',
    ],
    lessonStepReference:
        'template.es.a0.m06.competency.understand_direction.v1',
    recoveryMappings: [
      CompetencyRecoveryMapping(
        microCompetencyId: 'micro.es.a0.distinguish_left_right',
        reasonCode: CompetencyGapReasonCode.missingVocabulary,
        recoveryStepReferences: [
          CompetencyRecoveryStepReference(
            stepId: 'template.es.a0.m06.l038.left_right_choice.v1',
            sourceModuleId: 'es.a0.m06',
            sourceLessonId: 'es.a0.m06.l038',
            sourceStepId: 'template.es.a0.m06.l038.left_right_choice.v1',
          ),
        ],
        retryTaskId: 'task.es.a0.m06.understand_simple_direction',
      ),
    ],
  ),
  CompetencyAssessmentTask(
    taskId: 'task.es.a0.m06.ask_how_to_get_somewhere',
    competencyId: 'competency.es.a0.m06.ask_and_follow_basic_directions',
    assessedMicroCompetencyIds: ['micro.es.a0.ask_how_to_get_somewhere'],
    lessonStepReference: 'template.es.a0.m06.competency.ask_how_hotel.v1',
    recoveryMappings: [
      CompetencyRecoveryMapping(
        microCompetencyId: 'micro.es.a0.ask_how_to_get_somewhere',
        reasonCode: CompetencyGapReasonCode.incorrectQuestionForm,
        recoveryStepReferences: [
          CompetencyRecoveryStepReference(
            stepId: 'template.es.a0.m06.l040.route_question_choice.v1',
            sourceModuleId: 'es.a0.m06',
            sourceLessonId: 'es.a0.m06.l040',
            sourceStepId: 'template.es.a0.m06.l040.route_question_choice.v1',
          ),
        ],
        retryTaskId: 'task.es.a0.m06.ask_how_to_get_somewhere',
      ),
    ],
  ),
  CompetencyAssessmentTask(
    taskId: 'task.es.a0.m06.give_simple_directions',
    competencyId: 'competency.es.a0.m06.ask_and_follow_basic_directions',
    assessedMicroCompetencyIds: [
      'micro.es.a0.give_simple_directions',
      'micro.es.a0.understand_short_route_instruction',
    ],
    lessonStepReference: 'template.es.a0.m06.competency.give_directions.v1',
    recoveryMappings: [
      CompetencyRecoveryMapping(
        microCompetencyId: 'micro.es.a0.give_simple_directions',
        reasonCode: CompetencyGapReasonCode.wordOrderFailure,
        recoveryStepReferences: [
          CompetencyRecoveryStepReference(
            stepId: 'template.es.a0.m06.l038.fill_sigue_recto.v1',
            sourceModuleId: 'es.a0.m06',
            sourceLessonId: 'es.a0.m06.l038',
            sourceStepId: 'template.es.a0.m06.l038.fill_sigue_recto.v1',
          ),
        ],
        retryTaskId: 'task.es.a0.m06.give_simple_directions',
      ),
    ],
  ),
  CompetencyAssessmentTask(
    taskId: 'task.es.a0.m06.complete_route_exchange',
    competencyId: 'competency.es.a0.m06.ask_and_follow_basic_directions',
    assessedMicroCompetencyIds: [
      'micro.es.a0.ask_where_place_is',
      'micro.es.a0.ask_how_to_get_somewhere',
      'micro.es.a0.state_transport_method',
      'micro.es.a0.respond_in_direction_exchange',
      'micro.es.a0.complete_basic_route_exchange',
    ],
    lessonStepReference: 'template.es.a0.m06.competency.route_exchange.v1',
    isCentralTask: true,
    recoveryMappings: [
      CompetencyRecoveryMapping(
        microCompetencyId: 'micro.es.a0.complete_basic_route_exchange',
        reasonCode: CompetencyGapReasonCode.integrationFailure,
        recoveryStepReferences: [
          CompetencyRecoveryStepReference(
            stepId: 'template.es.a0.m06.l041.transport_answer_choice.v1',
            sourceModuleId: 'es.a0.m06',
            sourceLessonId: 'es.a0.m06.l041',
            sourceStepId: 'template.es.a0.m06.l041.transport_answer_choice.v1',
          ),
        ],
        retryTaskId: 'task.es.a0.m06.complete_route_exchange',
      ),
      CompetencyRecoveryMapping(
        microCompetencyId: 'micro.es.a0.respond_in_direction_exchange',
        reasonCode: CompetencyGapReasonCode.prerequisiteNotRetained,
        recoveryStepReferences: [
          CompetencyRecoveryStepReference(
            stepId: 'template.es.a0.m04.l025.dialogue_comprehension.v1',
            sourceModuleId: 'es.a0.m04',
            sourceLessonId: 'es.a0.m04.l025',
            sourceStepId: 'template.es.a0.m04.l025.dialogue_comprehension.v1',
          ),
        ],
        retryTaskId: 'task.es.a0.m06.complete_route_exchange',
      ),
    ],
  ),
  CompetencyAssessmentTask(
    taskId: 'task.es.a0.m07.get_attention',
    competencyId: 'competency.es.a0.m07.ask_for_basic_help',
    assessedMicroCompetencyIds: ['micro.es.a0.get_attention_politely'],
    lessonStepReference: 'template.es.a0.m07.competency.get_attention.v1',
    recoveryMappings: [
      CompetencyRecoveryMapping(
        microCompetencyId: 'micro.es.a0.get_attention_politely',
        reasonCode: CompetencyGapReasonCode.missingVocabulary,
        recoveryStepReferences: [
          CompetencyRecoveryStepReference(
            stepId: 'template.es.a0.m07.l044.attention_choice.v1',
            sourceModuleId: 'es.a0.m07',
            sourceLessonId: 'es.a0.m07.l044',
            sourceStepId: 'template.es.a0.m07.l044.attention_choice.v1',
          ),
        ],
        retryTaskId: 'task.es.a0.m07.get_attention',
      ),
    ],
  ),
  CompetencyAssessmentTask(
    taskId: 'task.es.a0.m07.ask_for_help',
    competencyId: 'competency.es.a0.m07.ask_for_basic_help',
    assessedMicroCompetencyIds: [
      'micro.es.a0.ask_for_help',
      'micro.es.a0.state_need_for_help',
    ],
    lessonStepReference: 'template.es.a0.m07.competency.ask_for_help.v1',
    recoveryMappings: [
      CompetencyRecoveryMapping(
        microCompetencyId: 'micro.es.a0.ask_for_help',
        reasonCode: CompetencyGapReasonCode.incorrectQuestionForm,
        recoveryStepReferences: [
          CompetencyRecoveryStepReference(
            stepId: 'template.es.a0.m07.l045.help_question_choice.v1',
            sourceModuleId: 'es.a0.m07',
            sourceLessonId: 'es.a0.m07.l045',
            sourceStepId: 'template.es.a0.m07.l045.help_question_choice.v1',
          ),
        ],
        retryTaskId: 'task.es.a0.m07.ask_for_help',
      ),
    ],
  ),
  CompetencyAssessmentTask(
    taskId: 'task.es.a0.m07.repair_communication',
    competencyId: 'competency.es.a0.m07.ask_for_basic_help',
    assessedMicroCompetencyIds: [
      'micro.es.a0.state_lack_of_understanding',
      'micro.es.a0.request_repetition',
      'micro.es.a0.request_slower_speech',
    ],
    lessonStepReference:
        'template.es.a0.m07.competency.repair_communication.v1',
    recoveryMappings: [
      CompetencyRecoveryMapping(
        microCompetencyId: 'micro.es.a0.request_repetition',
        reasonCode: CompetencyGapReasonCode.missingStructure,
        recoveryStepReferences: [
          CompetencyRecoveryStepReference(
            stepId: 'template.es.a0.m07.l046.fill_repita.v1',
            sourceModuleId: 'es.a0.m07',
            sourceLessonId: 'es.a0.m07.l046',
            sourceStepId: 'template.es.a0.m07.l046.fill_repita.v1',
          ),
        ],
        retryTaskId: 'task.es.a0.m07.repair_communication',
      ),
      CompetencyRecoveryMapping(
        microCompetencyId: 'micro.es.a0.state_lack_of_understanding',
        reasonCode: CompetencyGapReasonCode.prerequisiteNotRetained,
        recoveryStepReferences: [
          CompetencyRecoveryStepReference(
            stepId: 'template.es.a0.m01.l003.type_no_entiendo.v1',
            sourceModuleId: 'es.a0.m01',
            sourceLessonId: 'es.a0.m01.l003',
            sourceStepId: 'template.es.a0.m01.l003.type_no_entiendo.v1',
          ),
        ],
        retryTaskId: 'task.es.a0.m07.repair_communication',
      ),
    ],
  ),
  CompetencyAssessmentTask(
    taskId: 'task.es.a0.m07.find_service',
    competencyId: 'competency.es.a0.m07.ask_for_basic_help',
    assessedMicroCompetencyIds: ['micro.es.a0.ask_where_service_is'],
    lessonStepReference: 'template.es.a0.m07.competency.find_service.v1',
    recoveryMappings: [
      CompetencyRecoveryMapping(
        microCompetencyId: 'micro.es.a0.ask_where_service_is',
        reasonCode: CompetencyGapReasonCode.incorrectQuestionForm,
        recoveryStepReferences: [
          CompetencyRecoveryStepReference(
            stepId: 'template.es.a0.m07.l047.service_choice.v1',
            sourceModuleId: 'es.a0.m07',
            sourceLessonId: 'es.a0.m07.l047',
            sourceStepId: 'template.es.a0.m07.l047.service_choice.v1',
          ),
        ],
        retryTaskId: 'task.es.a0.m07.find_service',
      ),
    ],
  ),
  CompetencyAssessmentTask(
    taskId: 'task.es.a0.m07.request_emergency_help',
    competencyId: 'competency.es.a0.m07.ask_for_basic_help',
    assessedMicroCompetencyIds: [
      'micro.es.a0.request_medical_help',
      'micro.es.a0.request_police_help',
      'micro.es.a0.state_emergency',
    ],
    lessonStepReference:
        'template.es.a0.m07.competency.request_emergency_help.v1',
    recoveryMappings: [
      CompetencyRecoveryMapping(
        microCompetencyId: 'micro.es.a0.request_police_help',
        reasonCode: CompetencyGapReasonCode.missingVocabulary,
        recoveryStepReferences: [
          CompetencyRecoveryStepReference(
            stepId: 'template.es.a0.m07.l048.emergency_choice.v1',
            sourceModuleId: 'es.a0.m07',
            sourceLessonId: 'es.a0.m07.l048',
            sourceStepId: 'template.es.a0.m07.l048.emergency_choice.v1',
          ),
        ],
        retryTaskId: 'task.es.a0.m07.request_emergency_help',
      ),
    ],
  ),
  CompetencyAssessmentTask(
    taskId: 'task.es.a0.m07.complete_help_exchange',
    competencyId: 'competency.es.a0.m07.ask_for_basic_help',
    assessedMicroCompetencyIds: [
      'micro.es.a0.get_attention_politely',
      'micro.es.a0.ask_for_help',
      'micro.es.a0.request_medical_help',
      'micro.es.a0.respond_in_help_exchange',
      'micro.es.a0.complete_basic_help_exchange',
    ],
    lessonStepReference:
        'template.es.a0.m07.competency.complete_help_exchange.v1',
    isCentralTask: true,
    recoveryMappings: [
      CompetencyRecoveryMapping(
        microCompetencyId: 'micro.es.a0.complete_basic_help_exchange',
        reasonCode: CompetencyGapReasonCode.integrationFailure,
        recoveryStepReferences: [
          CompetencyRecoveryStepReference(
            stepId: 'template.es.a0.m07.l049.dialogue_comprehension.v1',
            sourceModuleId: 'es.a0.m07',
            sourceLessonId: 'es.a0.m07.l049',
            sourceStepId: 'template.es.a0.m07.l049.dialogue_comprehension.v1',
          ),
        ],
        retryTaskId: 'task.es.a0.m07.complete_help_exchange',
      ),
      CompetencyRecoveryMapping(
        microCompetencyId: 'micro.es.a0.respond_in_help_exchange',
        reasonCode: CompetencyGapReasonCode.prerequisiteNotRetained,
        recoveryStepReferences: [
          CompetencyRecoveryStepReference(
            stepId: 'template.es.a0.m04.l025.dialogue_comprehension.v1',
            sourceModuleId: 'es.a0.m04',
            sourceLessonId: 'es.a0.m04.l025',
            sourceStepId: 'template.es.a0.m04.l025.dialogue_comprehension.v1',
          ),
        ],
        retryTaskId: 'task.es.a0.m07.complete_help_exchange',
      ),
    ],
  ),
  CompetencyAssessmentTask(
    taskId: 'task.es.a0.m08.identify_family_member',
    competencyId: 'competency.es.a0.m08.describe_basic_family_and_home',
    assessedMicroCompetencyIds: [
      'micro.es.a0.identify_family_member',
      'micro.es.a0.state_family_relationship',
      'micro.es.a0.state_family_member_name',
    ],
    lessonStepReference:
        'template.es.a0.m08.competency.identify_family_member.v1',
    recoveryMappings: [
      CompetencyRecoveryMapping(
        microCompetencyId: 'micro.es.a0.state_family_relationship',
        reasonCode: CompetencyGapReasonCode.missingVocabulary,
        recoveryStepReferences: [
          CompetencyRecoveryStepReference(
            stepId: 'template.es.a0.m08.l053.who_sister_choice.v1',
            sourceModuleId: 'es.a0.m08',
            sourceLessonId: 'es.a0.m08.l053',
            sourceStepId: 'template.es.a0.m08.l053.who_sister_choice.v1',
          ),
          CompetencyRecoveryStepReference(
            stepId: 'template.es.a0.m04.l020.fill_se_llama.v1',
            sourceModuleId: 'es.a0.m04',
            sourceLessonId: 'es.a0.m04.l020',
            sourceStepId: 'template.es.a0.m04.l020.fill_se_llama.v1',
          ),
        ],
        retryTaskId: 'task.es.a0.m08.identify_family_member',
      ),
    ],
  ),
  CompetencyAssessmentTask(
    taskId: 'task.es.a0.m08.ask_about_family',
    competencyId: 'competency.es.a0.m08.describe_basic_family_and_home',
    assessedMicroCompetencyIds: ['micro.es.a0.ask_about_family'],
    lessonStepReference: 'template.es.a0.m08.competency.ask_about_family.v1',
    recoveryMappings: [
      CompetencyRecoveryMapping(
        microCompetencyId: 'micro.es.a0.ask_about_family',
        reasonCode: CompetencyGapReasonCode.incorrectQuestionForm,
        recoveryStepReferences: [
          CompetencyRecoveryStepReference(
            stepId: 'template.es.a0.m08.l054.type_tienes_hermanos.v1',
            sourceModuleId: 'es.a0.m08',
            sourceLessonId: 'es.a0.m08.l054',
            sourceStepId: 'template.es.a0.m08.l054.type_tienes_hermanos.v1',
          ),
        ],
        retryTaskId: 'task.es.a0.m08.ask_about_family',
      ),
    ],
  ),
  CompetencyAssessmentTask(
    taskId: 'task.es.a0.m08.answer_family_question',
    competencyId: 'competency.es.a0.m08.describe_basic_family_and_home',
    assessedMicroCompetencyIds: [
      'micro.es.a0.state_have_family_member',
      'micro.es.a0.state_basic_family_information',
    ],
    lessonStepReference:
        'template.es.a0.m08.competency.answer_family_question.v1',
    recoveryMappings: [
      CompetencyRecoveryMapping(
        microCompetencyId: 'micro.es.a0.state_have_family_member',
        reasonCode: CompetencyGapReasonCode.incorrectVerbForm,
        recoveryStepReferences: [
          CompetencyRecoveryStepReference(
            stepId: 'template.es.a0.m08.l054.tengo_form_choice.v1',
            sourceModuleId: 'es.a0.m08',
            sourceLessonId: 'es.a0.m08.l054',
            sourceStepId: 'template.es.a0.m08.l054.tengo_form_choice.v1',
          ),
        ],
        retryTaskId: 'task.es.a0.m08.answer_family_question',
      ),
    ],
  ),
  CompetencyAssessmentTask(
    taskId: 'task.es.a0.m08.identify_room_object',
    competencyId: 'competency.es.a0.m08.describe_basic_family_and_home',
    assessedMicroCompetencyIds: [
      'micro.es.a0.identify_home_room',
      'micro.es.a0.name_household_object',
    ],
    lessonStepReference:
        'template.es.a0.m08.competency.identify_room_object.v1',
    recoveryMappings: [
      CompetencyRecoveryMapping(
        microCompetencyId: 'micro.es.a0.identify_home_room',
        reasonCode: CompetencyGapReasonCode.missingVocabulary,
        recoveryStepReferences: [
          CompetencyRecoveryStepReference(
            stepId: 'template.es.a0.m08.l055.room_choice.v1',
            sourceModuleId: 'es.a0.m08',
            sourceLessonId: 'es.a0.m08.l055',
            sourceStepId: 'template.es.a0.m08.l055.room_choice.v1',
          ),
        ],
        retryTaskId: 'task.es.a0.m08.identify_room_object',
      ),
    ],
  ),
  CompetencyAssessmentTask(
    taskId: 'task.es.a0.m08.ask_and_state_location',
    competencyId: 'competency.es.a0.m08.describe_basic_family_and_home',
    assessedMicroCompetencyIds: [
      'micro.es.a0.ask_where_person_or_object_is',
      'micro.es.a0.state_person_or_object_location',
    ],
    lessonStepReference:
        'template.es.a0.m08.competency.ask_and_state_location.v1',
    recoveryMappings: [
      CompetencyRecoveryMapping(
        microCompetencyId: 'micro.es.a0.ask_where_person_or_object_is',
        reasonCode: CompetencyGapReasonCode.incorrectQuestionForm,
        recoveryStepReferences: [
          CompetencyRecoveryStepReference(
            stepId: 'template.es.a0.m06.l037.where_question_choice.v1',
            sourceModuleId: 'es.a0.m06',
            sourceLessonId: 'es.a0.m06.l037',
            sourceStepId: 'template.es.a0.m06.l037.where_question_choice.v1',
          ),
        ],
        retryTaskId: 'task.es.a0.m08.ask_and_state_location',
      ),
    ],
  ),
  CompetencyAssessmentTask(
    taskId: 'task.es.a0.m08.describe_basic_home',
    competencyId: 'competency.es.a0.m08.describe_basic_family_and_home',
    assessedMicroCompetencyIds: [
      'micro.es.a0.describe_basic_home',
      'micro.es.a0.understand_short_home_description',
    ],
    lessonStepReference:
        'template.es.a0.m08.competency.basic_home_description.v1',
    recoveryMappings: [
      CompetencyRecoveryMapping(
        microCompetencyId: 'micro.es.a0.describe_basic_home',
        reasonCode: CompetencyGapReasonCode.missingStructure,
        recoveryStepReferences: [
          CompetencyRecoveryStepReference(
            stepId: 'template.es.a0.m08.l057.type_basic_home_profile.v1',
            sourceModuleId: 'es.a0.m08',
            sourceLessonId: 'es.a0.m08.l057',
            sourceStepId: 'template.es.a0.m08.l057.type_basic_home_profile.v1',
          ),
        ],
        retryTaskId: 'task.es.a0.m08.describe_basic_home',
      ),
    ],
  ),
  CompetencyAssessmentTask(
    taskId: 'task.es.a0.m08.family_home_exchange',
    competencyId: 'competency.es.a0.m08.describe_basic_family_and_home',
    assessedMicroCompetencyIds: [
      'micro.es.a0.identify_family_member',
      'micro.es.a0.state_family_relationship',
      'micro.es.a0.state_person_or_object_location',
      'micro.es.a0.respond_in_family_home_exchange',
      'micro.es.a0.complete_basic_family_home_exchange',
    ],
    lessonStepReference:
        'template.es.a0.m08.competency.family_home_exchange.v1',
    isCentralTask: true,
    recoveryMappings: [
      CompetencyRecoveryMapping(
        microCompetencyId: 'micro.es.a0.complete_basic_family_home_exchange',
        reasonCode: CompetencyGapReasonCode.integrationFailure,
        recoveryStepReferences: [
          CompetencyRecoveryStepReference(
            stepId: 'template.es.a0.m08.l058.dialogue_comprehension.v1',
            sourceModuleId: 'es.a0.m08',
            sourceLessonId: 'es.a0.m08.l058',
            sourceStepId: 'template.es.a0.m08.l058.dialogue_comprehension.v1',
          ),
        ],
        retryTaskId: 'task.es.a0.m08.family_home_exchange',
      ),
      CompetencyRecoveryMapping(
        microCompetencyId: 'micro.es.a0.respond_in_family_home_exchange',
        reasonCode: CompetencyGapReasonCode.prerequisiteNotRetained,
        recoveryStepReferences: [
          CompetencyRecoveryStepReference(
            stepId: 'template.es.a0.m04.l025.dialogue_comprehension.v1',
            sourceModuleId: 'es.a0.m04',
            sourceLessonId: 'es.a0.m04.l025',
            sourceStepId: 'template.es.a0.m04.l025.dialogue_comprehension.v1',
          ),
        ],
        retryTaskId: 'task.es.a0.m08.family_home_exchange',
      ),
    ],
  ),
  CompetencyAssessmentTask(
    taskId: 'task.es.a0.build_personal_identity_profile',
    competencyId: 'competency.es.a0.m03.describe_basic_personal_identity',
    assessedMicroCompetencyIds: [
      'micro.es.a0.build_personal_identity_profile',
      'micro.es.a0.exchange_personal_identity_information',
    ],
    lessonStepReference:
        'template.es.a0.m03.competency.type_identity_profile.v1',
    isCentralTask: true,
    recoveryMappings: [
      CompetencyRecoveryMapping(
        microCompetencyId: 'micro.es.a0.build_personal_identity_profile',
        reasonCode: CompetencyGapReasonCode.integrationFailure,
        recoveryStepReferences: [
          CompetencyRecoveryStepReference(
            stepId: 'template.es.a0.m03.l015.origin_residence_contrast.v1',
            sourceModuleId: 'es.a0.m03',
            sourceLessonId: 'es.a0.m03.l015',
            sourceStepId:
                'template.es.a0.m03.l015.origin_residence_contrast.v1',
          ),
        ],
        retryTaskId: 'task.es.a0.build_personal_identity_profile',
      ),
    ],
  ),
];

LessonContentReference templateReference(String templateId) {
  final assetPath = templateId.startsWith('template.es.a0.m07.')
      ? 'assets/languages/spanish/templates/module_7_help.json'
      : templateId.startsWith('template.es.a0.m06.')
      ? 'assets/languages/spanish/templates/module_6_transport.json'
      : templateId.startsWith('template.es.a0.m05.')
      ? 'assets/languages/spanish/templates/module_5_shopping.json'
      : templateId.startsWith('template.es.a0.m04.')
      ? 'assets/languages/spanish/templates/module_4_people.json'
      : templateId.startsWith('template.es.a0.m03.')
      ? 'assets/languages/spanish/templates/module_3_identity.json'
      : templateId.startsWith('template.es.a0.m01.')
      ? 'assets/languages/spanish/templates/module_1_first_words.json'
      : 'assets/languages/spanish/templates/module_2_names.json';
  return LessonContentReference(
    type: 'exercise_template',
    assetPath: assetPath,
    referenceId: templateId,
  );
}
