/* eslint-disable react/jsx-max-depth */
import { useBackend } from '../backend';
import { Button, LabeledList, LabeledControls, Input, NumberInput, Section, Box, Stack, Dropdown, Flex, Divider } from '../components';
import { Window } from '../layouts';

type WindowData = {
  ERT_options: Array<ResponseTeamData>;
  custom_datum: string;
  selected_ERT_option: ResponseTeamData;
  teamsize: number;
  mission: string;
  polldesc: string;
  rename_team: string;
  enforce_human: boolean;
  open_armory: boolean;
  spawn_admin: boolean;
  leader_experience: boolean;
  give_cyberimps: boolean;
  spawn_mechs: boolean;
}

type ResponseTeamData = {
  name: string;
  path: string;
  leaderAntag: string;
  memberAntags: string[];
  previewIcon?: string;
}

export const ErtMaker = (props, context) => {
  const { act, data } = useBackend<WindowData>(context);
  const {
    ERT_options,
    custom_datum,
    selected_ERT_option,
    // customization basically
    teamsize,
    mission,
    polldesc,
    rename_team,
    enforce_human,
    open_armory,
    spawn_admin,
    leader_experience,
    give_cyberimps,
    spawn_mechs,
  } = data;

  let ert_options_strings = [];
  let temp = [...ERT_options]; // I know this is stupid but
  // i can't figure out why it won't let me iterate
  // over ERT_options
  for (let option of temp) {
    ert_options_strings = [
      ...ert_options_strings,
      option.name,
    ];
  }

  return (
    <Window
      title="Summon ERT"
      height={500}
      width={700}>
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item align="center">
            <Dropdown
              options={ert_options_strings}
              selected={selected_ERT_option.name}
              nochevron
              noscroll
              width="300px"
              onSelected={(value) => act('pickERT', {
                selectedERT: ERT_options.find((obj) => {
                  return (obj.name === value);
                }).path,
              })}
            />
          </Stack.Item>
          <Stack.Divider />
          <Stack.Item height="100%">
            <Stack basis="100%" height="100%">
              <Stack.Item>
                <Section title="Customization"
                  buttons={
                    <Button
                      color="red"
                      tooltip="View Variables"
                      tooltipPosition="left"
                      icon="pen"
                      onClick={() => act('vv')}
                    />
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
                    <LabeledList.Item label="Team Size"buttons={
                      <Button
                        icon="info"
                        tooltip="Response Team Size. How many members do we want? Minimum: 1"
                        tooltipPosition="right"
                        ml={-.5}
                      />
                    }>
                      <NumberInput
                        value={teamsize}
                        onChange={(e, val) => act('setTeamSize', {
                          new_value: val,
                        })}
                      />
                    </LabeledList.Item>
                  </LabeledList>
                </Section>
                <Divider />
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
                            checked={give_cyberimps}
                            onClick={() => act('giveCyberimps')}
                            mx={.5}
                            tooltip="Make ERT spawn with their outfit's cybernetic implants, if such exist."
                            tooltipPosition="bottom"
                          >Give Cyberimps
                          </Button.Checkbox>
                        </Flex.Item>
                      </Flex>
                    </Stack.Item>
                    <Stack.Item>
                      <Flex>
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
              </Stack.Item>
              {selected_ERT_option.previewIcon && (
                <Stack.Item>
                  <Section title="ERT Preview" >
                    <Box
                      as="img"
                      // eslint-disable-next-line max-len
                      src={`data:image/jpeg;base64,${selected_ERT_option.previewIcon}`}
                      width={20}
                      height={20}
                      style={{
                        '-ms-interpolation-mode': 'nearest-neighbor',
                      }}
                    />
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
                </Stack.Item>
              )}
            </Stack>
          </Stack.Item>
          <Stack.Divider />
          <Stack.Item>
            <Flex justify="space-around" align="center">
              <Flex.Item grow={4} />
              <Flex.Item grow>
                <Button
                  fluid
                  onClick={() => act('spawnERT')}
                >Summon ERT
                </Button>
              </Flex.Item>
              <Flex.Item align="end" grow={4} />
            </Flex>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );

};
