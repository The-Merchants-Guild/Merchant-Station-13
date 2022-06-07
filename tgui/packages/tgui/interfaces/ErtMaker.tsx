import { useBackend, useLocalState } from '../backend';
import { Button, LabeledList, NoticeBox, Input, NumberInput, Section, Box, Stack, Dropdown, Flex, Divider, Collapsible, Dimmer } from '../components';
import { Window } from '../layouts';

type WindowData = {
  ERT_options: Array<ResponseTeamData>;
  custom_ERT_options: Array<ResponseTeamData>;
  custom_datum: string;
  editing_mode: boolean;
  selected_ERT_option: ResponseTeamData;
  selected_preview_role: string;
  teamsize: number;
  mech_amount: number;
  mission: string;
  polldesc: string;
  rename_team: string;
  enforce_human: boolean;
  open_armory: boolean;
  spawn_admin: boolean;
  leader_experience: boolean;
  spawn_mechs: boolean;
}

type ResponseTeamData = {
  name: string;
  path: string;
  ref?: string;
  leaderAntag?: AntagData;
  memberAntags?: Array<AntagData>;
  previewIcon?: string;
}

type AntagData = {
  role: string;
  path?: string;
  ref?: string;
  outfit: string;
  plasmaOutfit: string;
  mech: string;
}

export const ErtMaker = (props, context) => {
  const { act, data } = useBackend<WindowData>(context);
  const {
    ERT_options,
    custom_ERT_options,
    selected_ERT_option,
    custom_datum,
    editing_mode,
  } = data;

  let ert_options_strings = [];
  for (let option of ERT_options) {
    ert_options_strings = [
      ...ert_options_strings,
      option.name,
    ];
  }
  if (custom_ERT_options.length > 0) {
    ert_options_strings = [
      ...ert_options_strings,
      "--- CUSTOM ERTS ---",
    ];
    for (let option of custom_ERT_options) {
      ert_options_strings = [
        ...ert_options_strings,
        option.name + " " + option.ref,
      ];
    }
  }

  const pickERT = (ertString: string) => {
    let returnval = ERT_options.find((obj) => {
      return (obj.name === ertString);
    });
    if (returnval) {
      act('pickERT', {
        selectedERT: returnval.path,
      });
    }
    else {
      returnval = custom_ERT_options.find((obj) => {
        return ((obj.name + " " + obj.ref) === ertString);
      });
      if (returnval) {
        act('pickERT', {
          selectedREF: returnval.ref,
        });
      }
    }
  };

  let isCustom = selected_ERT_option.path === custom_datum;

  { return (
    <Window
      title="Summon ERT"
      height={500}
      width={700}>
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item align="center">
            <Flex>
              <Flex.Item mr={.5}>
                {(isCustom && !editing_mode) && (
                  <Button
                    color="red"
                    tooltip="Remove selected ERT"
                    tooltipPosition="bottom"
                    icon="trash"
                    onClick={() => act('deleteSelectedERT')}
                  />) || (<Box />)}
              </Flex.Item>
              <Flex.Item>
                {!editing_mode && (
                  <Button
                    color="green"
                    tooltip="Add new custom ERT"
                    tooltipPosition="bottom"
                    icon="plus"
                    onClick={() => act('addNewERT')}
                  />
                ) || <Box />}
              </Flex.Item>
              <Flex.Item mx={.5}>
                {!editing_mode && (
                  <Dropdown
                    options={ert_options_strings}
                    displayText={selected_ERT_option.name}
                    nochevron
                    noscroll
                    width="300px"
                    onSelected={(value) => pickERT(value)}
                  />
                ) || (
                  <Input
                    value={selected_ERT_option.name}
                    width="300px"
                    onChange={(e, val) => act('setSelectedName', {
                      newName: val,
                    })}
                  />
                )}
              </Flex.Item>
              <Flex.Item width={isCustom ? 3 : 1}>
                {!editing_mode && (
                  <Button
                    color="green"
                    tooltip="Load ERT from JSON file"
                    tooltipPosition="bottom"
                    icon="file-upload"
                    onClick={() => act('loadFromFile')}
                  />
                ) || <Box />}
              </Flex.Item>
            </Flex>
          </Stack.Item>
          <Stack.Divider />
          <Stack.Item height="100%">
            <ErtBasicEditing />
          </Stack.Item>
          <Stack.Divider />
          <Stack.Item>
            <Flex justify="space-around" align="center">
              <Flex.Item grow={4} />
              <Flex.Item grow>
                {!editing_mode && (
                  <Button
                    fluid
                    onClick={() => act('spawnERT')}
                  >Summon ERT
                  </Button>)
                  || (
                    <NoticeBox
                      danger
                      m={-.5}
                    >
                      Unable to spawn ERT while editing.
                    </NoticeBox>
                  )}
              </Flex.Item>
              <Flex.Item align="end" grow={4} />
            </Flex>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  ); }

};



const ErtPreviewScreen = (props, context) => {
  const { act, data } = useBackend<WindowData>(context);
  const {
    selected_ERT_option,
    selected_preview_role,
    editing_mode,
  } = data;

  const {
    leaderAntag,
    memberAntags,
    previewIcon,
  } = selected_ERT_option;

  let all_antags = [
    leaderAntag,
    ...memberAntags,
  ];

  let antag_options_strings = [];
  for (let option of all_antags) {
    antag_options_strings = [
      ...antag_options_strings,
      option.role,
    ];
  }

  let showDimmer = ( // Show dimmer if...
    (all_antags.length <= 0) // We have an empty list
    || !previewIcon // There is no preview icon
    || editing_mode // We are editing
  );
  // remove duplicates
  antag_options_strings = antag_options_strings.filter(
    (elem, index, self) => {
      return index === self.indexOf(elem);
    });


  return (
    <Section title="ERT Preview" buttons={
      (!showDimmer && <Dropdown
        options={antag_options_strings}
        nochevron
        noscroll
        displayText={selected_preview_role}
        onSelected={(value) => act('pickPreviewRole', {
          newPreviewRole: value,
        })}
      />)
    }>{
        !showDimmer && (
          <Box
            as="img"
            // eslint-disable-next-line max-len
            src={`data:image/jpeg;base64,${previewIcon}`}
            width={18}
            height={18}
            style={{
              '-ms-interpolation-mode': 'nearest-neighbor',
            }}
          />
        ) || (
          <Box
            width={18}
            height={18}
          >
            <Dimmer>
              ERT preview unavaiable.
            </Dimmer>
          </Box>
        )
      }
      <Flex justify="space-between">
        <Flex.Item>
          <Button
            icon="angle-left"
            onClick={() => act('rotatePreview', {
              direction: -1,
            })}
          />
        </Flex.Item>
        <Flex.Item>
          <Button
            icon="angle-right"
            onClick={() => act('rotatePreview', {
              direction: 1,
            })}
          />
        </Flex.Item>
      </Flex>
    </Section>
  );
};

const ErtAntag = (props, context) => {
  const { act, data } = useBackend<WindowData>(context);
  const {
    role,
    path,
    outfit,
    plasmaOutfit,
    mech,
  } = props.antagData;

  const [selectedAntagNum, setSelectedAntagNum] = useLocalState(
    context, 'selected_antag_editing_num', 0);

  return (
    <Stack>
      <Box width={36.8}>
        <LabeledList>
          <LabeledList.Item label="Role"
            buttons={
              <Button
                icon="info"
                tooltip="Role of this antagonist. Basically their job. Duplicates not recommended."
                tooltipPosition="left"
                ml={-.5}
              />
            }>
            <Input
              fluid
              value={role}
              onChange={(e, val) => act("setAntagRole", {
                newRole: val,
                antagNum: selectedAntagNum,
              })}
            />
          </LabeledList.Item>
          <LabeledList.Item label="Outfit"
            buttons={
              <Button
                icon="info"
                tooltip="The outfit of this antagonist. Gear they spawn with."
                tooltipPosition="left"
                ml={-.5}
              />
            }>
            <Button
              fluid
              onClick={() => act("setAntagOutfit", {
                antagNum: selectedAntagNum,
              })}>
              {outfit}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Plasmeme"
            buttons={
              <Button
                icon="info"
                tooltip="The outfit of this antagonist for plasmamen. Gear they spawn with."
                tooltipPosition="left"
                ml={-.5}
              />
            }>
            <Button
              fluid
              onClick={() => act("setAntagOutfit", {
                antagNum: selectedAntagNum,
                plasmaman_outfit: true,
              })}>
              {plasmaOutfit}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Mech"
            buttons={
              <Button
                icon="info"
                tooltip="The mech this antagonist spawns with, if the spawn with mechs toggle is enabled."
                tooltipPosition="left"
                ml={-.5}
              />
            }>
            <Button
              fluid
              onClick={() => act("setAntagMech", {
                antagNum: selectedAntagNum,
              })}>
              {mech}
            </Button>
          </LabeledList.Item>
        </LabeledList>
      </Box>
    </Stack>
  );
};

const ErtAntagEditing = (props, context) => {
  const { act, data } = useBackend<WindowData>(context);
  const {
    selected_ERT_option,
  } = data;
  const {
    leaderAntag,
    memberAntags,
  } = selected_ERT_option;

  let all_antags = [
    leaderAntag,
    ...memberAntags,
  ];

  const [selectedAntagNum, setSelectedAntagNum] = useLocalState(
    context, 'selected_antag_editing_num', 0);

  return (
    <Section title="Antag Editing" buttons={
      <Box>
        {(selectedAntagNum > 1) && (
          <Button
            icon="minus"
            tooltip="Remove selected antagonist"
            onClick={() => {
              if (selectedAntagNum === all_antags.length-1) {
                setSelectedAntagNum(Math.max(selectedAntagNum-1, 0));
              }
              act('removeAntagonist', {
                antagNum: selectedAntagNum,
              });
            }}
          />
        )}
        <Button
          icon="plus"
          tooltip="Add new antagonist"
          onClick={() => {
            act('addAntagonist');
            setSelectedAntagNum(all_antags.length-1);
          }}
        />
        <Button
          icon="angle-left"
          onClick={() => {
            setSelectedAntagNum(Math.max(selectedAntagNum-1, 0));
          }}
        />
        <NumberInput
          minValue={0}
          maxValue={all_antags.length-1}
          value={selectedAntagNum}
          onChange={(e, val) => {
            setSelectedAntagNum(val);
          }} />
        <Button
          icon="angle-right"
          onClick={() => {
            // eslint-disable-next-line
            setSelectedAntagNum(Math.min(selectedAntagNum+1, all_antags.length-1));
          }}
        />
      </Box>
    }>
      <Stack>
        <Stack.Item>
          <ErtAntag antagData={all_antags[selectedAntagNum]} />
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const ErtTogglesLong = (props, context) => {
  const { act, data } = useBackend<WindowData>(context);
  const {
    enforce_human,
    open_armory,
    spawn_admin,
    leader_experience,
    spawn_mechs,
  } = data;
  return (
    <Section title="Toggles">
      <Stack vertical>
        <Stack.Item>
          <Flex justify="space-evenly">
            <Flex.Item grow>
              <Button.Checkbox fluid
                checked={open_armory}
                onClick={() => act('openArmory')}
                mx={.5}
                tooltip="Open armory doors when the ERT spawns."
                tooltipPosition="top"
              >Open Armory Doors
              </Button.Checkbox>
            </Flex.Item>
            <Flex.Item grow>
              <Button.Checkbox fluid
                checked={enforce_human}
                onClick={() => act('enforceHuman')}
                mx={.5}
                tooltip="Force ERT members to spawn as humans."
                tooltipPosition="top"
              >Enforce Human Authority
              </Button.Checkbox>
            </Flex.Item>
          </Flex>
        </Stack.Item>
        <Stack.Item>
          <Flex justify="space-evenly">
            <Flex.Item grow>
              <Button.Checkbox fluid
                checked={spawn_admin}
                onClick={() => act('spawnAdmin')}
                mx={.5}
                tooltip="Spawn yourself as a briefing officer. Must be a ghost."
                tooltipPosition="bottom"
              >Spawn Admin
              </Button.Checkbox>
            </Flex.Item>
            <Flex.Item grow>
              <Button.Checkbox fluid
                checked={leader_experience}
                onClick={() => act('leaderExperience')}
                mx={.5}
                tooltip="Pick one of the most experienced players to be the ERT leader."
                tooltipPosition="bottom"
              >Leader Experience
              </Button.Checkbox>
            </Flex.Item>
            <Flex.Item grow>
              <Button.Checkbox fluid
                checked={spawn_mechs}
                onClick={() => act('spawnMechs')}
                mx={.5}
                tooltip="Make ERT spawn with assigned mechs, if such exist."
                tooltipPosition="bottom"
              >Spawn Mechs
              </Button.Checkbox>
            </Flex.Item>
          </Flex>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

// For editing mode. Less info, less space.
const ErtTogglesShort = (props, context) => {
  const { act, data } = useBackend<WindowData>(context);
  const {
    enforce_human,
    open_armory,
    spawn_admin,
    leader_experience,
    spawn_mechs,
  } = data;
  return (
    <Section title="Toggle Defaults" my={1}>
      <Stack vertical >
        <Stack.Item>
          <Stack>
            <Stack.Item>
              <Button.Checkbox
                fluid
                checked={open_armory}
                onClick={() => act('openArmory')}
                tooltip="Set whether or not armory doors should open when the ERT spawns by default."
                tooltipPosition="bottom"
              >Armory
              </Button.Checkbox>
            </Stack.Item>
            <Stack.Item>
              <Button.Checkbox
                fluid
                checked={enforce_human}
                onClick={() => act('enforceHuman')}
                tooltip="Set whether or not ERT members should be forced to spawn as humans by default."
                tooltipPosition="bottom"
              >Human
              </Button.Checkbox>
            </Stack.Item>
            <Stack.Item>
              <Button.Checkbox
                fluid
                checked={spawn_admin}
                onClick={() => act('spawnAdmin')}
                tooltip="Set whether or not you should be spawned as a briefing officer by default."
                tooltipPosition="bottom"
              >Brief
              </Button.Checkbox>
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <Stack.Item>
          <Stack>
            <Stack.Item>
              <Button.Checkbox
                fluid
                checked={spawn_mechs}
                onClick={() => act('spawnMechs')}
                tooltip="Set whether or not the ERT should spawn with mechs by default."
                tooltipPosition="bottom"
              >Mechs
              </Button.Checkbox>
            </Stack.Item>
            <Stack.Item>
              <Button.Checkbox
                fluid
                checked={leader_experience}
                onClick={() => act('leaderExperience')}
                tooltip="Set whether or not the ERT should select an experienced leader by default"
                tooltipPosition="bottom"
              >Experience
              </Button.Checkbox>
            </Stack.Item>
          </Stack>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

// Long as hell due to tooltips. But I like tooltips.
const ErtBasicEditing = (props, context) => {
  const { act, data } = useBackend<WindowData>(context);
  const {
    editing_mode,
    selected_ERT_option,
    custom_datum,
    // customization basically
    teamsize,
    mech_amount,
    mission,
    polldesc,
    rename_team,
  } = data;

  const [selectedAntagNum, setSelectedAntagNum] = useLocalState(
    context, 'selected_antag_editing_num', 0);

  let isCustom = selected_ERT_option.path === custom_datum;

  return (
    <Stack basis="100%" height="100%">
      <Stack.Item>
        <Section title="Customization"
          buttons={
            <Box>
              {isCustom && (
                <Button
                  color="green"
                  tooltip="Save to file"
                  tooltipPosition="bottom"
                  icon="save"
                  onClick={() => act('saveToFile')}
                />
              ) || <Box />}
              <Button
                color="red"
                tooltip={editing_mode && "View Variables" || "View ERT Variables"}
                tooltipPosition="bottom"
                icon="pen"
                onClick={() => {
                  if (!editing_mode) { act('vv'); }
                  else { act('vvERT'); }
                }}
              />
              <Button
                color="red"
                tooltip="Edit ERT"
                tooltipPosition="top"
                icon="cog"
                onClick={() => {
                  act('editSelectedERT');
                  setSelectedAntagNum(0);
                }}
              />
            </Box>
          }
        >
          <LabeledList>
            <LabeledList.Item label="Team Name" buttons={
              <Button
                icon="info"
                tooltip="Response team name. Shows up in roundend report."
                tooltipPosition="right"
                ml={-.5}
              />
            }>
              <Input
                fluid
                value={rename_team || "Emergency Response Team"}
                onChange={(e, val) => act('setTeamName', {
                  new_value: val,
                })}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Team Mission"buttons={
              <Button
                icon="info"
                tooltip="Objective given to response team."
                tooltipPosition="right"
                ml={-.5}
              />
            }>
              <Input
                fluid
                value={mission}
                onChange={(e, val) => act('setMission', {
                  new_value: val,
                })}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Poll Description"buttons={
              <Button
                icon="info"
                tooltip="Ghost Poll Description, used in ghost join prompt description"
                tooltipPosition="right"
                ml={-.5}
              />
            }>
              <Input
                fluid
                value={polldesc}
                onChange={(e, val) => act('setPollDesc', {
                  new_value: val,
                })}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Team Size" buttons={
              <Button
                icon="info"
                tooltip="Response Team Size. How many members do we want? Minimum: 1"
                tooltipPosition="right"
                ml={-.5}

              />
            }>
              <NumberInput
                value={teamsize}
                minValue={1}
                onChange={(e, val) => act('setTeamSize', {
                  new_value: val,
                })}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Mech Amount" buttons={
              <Button
                icon="info"
                tooltip="Amount of mechs to spawn. Values range from 0 to ERT team size."
                tooltipPosition="right"
                ml={-.5}
              />
            }>
              <NumberInput
                value={mech_amount}
                minValue={0}
                maxValue={teamsize}
                onChange={(e, val) => act('setMechAmount', {
                  new_value: val,
                })}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
        {editing_mode && (
          <Box>
            <Divider />
            <ErtAntagEditing />
            <Divider />
          </Box>
        )
        || (
          <Box>
            <Divider />
            <ErtTogglesLong />
          </Box>
        )}
      </Stack.Item>
      <Stack.Item>
        <Stack vertical>
          <Stack.Item>
            <ErtPreviewScreen />
          </Stack.Item>
          {editing_mode && (
            <ErtTogglesShort />
          ) || (<Box />)}
        </Stack>
      </Stack.Item>
    </Stack>
  );
};
