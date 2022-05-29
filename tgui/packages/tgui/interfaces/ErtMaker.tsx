import { useBackend } from '../backend';
import { Button, LabeledList, ProgressBar, Section, Box, Stack, Dropdown, Flex } from '../components';
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
            <Stack basis="100%">
              <Stack.Item>
                <LabeledList>
                  <LabeledList.Item label="selected">{selected_ERT_option.name} - {selected_ERT_option.path}</LabeledList.Item>
                  <LabeledList.Item label="custom_datum">{custom_datum}</LabeledList.Item>
                  <LabeledList.Item label="teamsize">{teamsize}</LabeledList.Item>
                  <LabeledList.Item label="mission">{mission}</LabeledList.Item>
                  <LabeledList.Item label="polldesc">{polldesc}</LabeledList.Item>
                  <LabeledList.Item label="rename_team">{rename_team}</LabeledList.Item>
                  <LabeledList.Item label="enforce_human">{enforce_human}</LabeledList.Item>
                  <LabeledList.Item label="open_armory">{open_armory}</LabeledList.Item>
                  <LabeledList.Item label="spawn_admin">{spawn_admin}</LabeledList.Item>
                  <LabeledList.Item label="leader_experience">{leader_experience}</LabeledList.Item>
                  <LabeledList.Item label="give_cyberimps">{give_cyberimps}</LabeledList.Item>
                </LabeledList>
              </Stack.Item>
              {selected_ERT_option.previewIcon && (
                <Stack.Item>
                  <Section title="ERT Preview" />
                  <img
                    src={`data:image/jpeg;base64,${selected_ERT_option.previewIcon}`}
                  />
                </Stack.Item>
              )}
            </Stack>
          </Stack.Item>
          <Stack.Divider />
          <Stack.Item align="center">
            <Button
              fluid
              onClick={() => act('spawnERT')}
            >Summon ERT
            </Button>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );

};
