import { useBackend } from '../backend';
import { Table, Button, LabeledList, NoticeBox, Section, Flex } from '../components';
import { Window } from '../layouts';

export const DeathmatchLobby = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Window
      title="Deathmatch Lobby"
      width={360}
      height={600}>
      <Window.Content>
        sus amogus
      </Window.Content>
    </Window>
  );
};
